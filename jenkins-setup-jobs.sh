#!/usr/bin/env bash

function _usage_main() {
  echo "Usage: ${0##*/} [OPTIONS]"
  echo "-h|--help  : Print this helper."
  echo "-U|--url   : The Jenkins URL. Default is: http://jenkins.local/aallrd."
  echo "-u|--user  : The Jenkins user. Default is: aallard"
  echo "-t|--token : The users's Jenkins API token. Default is: \${API_TOKEN}"
}

function _main() {
  local url user token crumb ret docker_agent_templates job_name

  _parse_args "${@}"

  url="${__user:-http://jenkins.local/aallrd}"
  user="${__user:-aallard}"
  if [[ ! -z ${API_TOKEN+x} ]] ; then
    token="${API_TOKEN}"
  else
    echo "You must export the API_TOKEN for user ${user} in the current shell."
    exit 1
  fi

  crumb=$(curl -s "${url}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)" -u "${user}:${token}")
  if [[ ${crumb} == "" ]] ; then
    echo "Failed to generate crumb from ${url} for user ${user}."
    exit 1
  fi

  # Creating mother seed job
  ret=$(curl -s -o /dev/null -w "%{http_code}" -XGET "${url}/job/docker-images-mother-seed-job" -u "${user}:${token}")
  if [[ "${ret}" == "404" ]] ; then
    ret=$(curl -s -XPOST "${url}/createItem?name=docker-images-mother-seed-job" -u "${user}:${token}" --data-binary @jenkins/mother-seed-job.xml -H "${crumb}" -H 'Content-Type:text/xml')
    if [[ "${ret}" != "" ]] ; then
      echo "Failed to create mother seed job."
      echo "${ret}"
      exit 1
    else
      echo "Mother seed job created."
    fi
  else
    echo "Mother seed job already exists, ignoring."
  fi

  # Trigger build mother seed job
  ret=$(curl -s -XPOST "${url}/job/docker-images-mother-seed-job/build" -u ${user}:${token} -H "${crumb}") 
  if [[ "${ret}" != "" ]] ; then
    echo "Failed to trigger the build of the mother seed job."
    echo "${ret}"
    exit 1
  else
    echo "Waiting for mother seed job end of build..." ; sleep 5
  fi

  # Trigger build seed jobs
  ret=$(curl -s -XPOST "${url}/job/docker-images-seed-jobs/build" -u ${user}:${token} -H "${crumb}")
  if [[ "${ret}" != "" ]] ; then
    echo "Failed to trigger the build of the seed jobs."
    echo "${ret}"
    exit 1
  fi

  # Create docker agent templates
  docker_agent_templates=($(find ./ -type f -name "jenkins-docker-agent-template.xml" | xargs))
  for docker_agent_template in ${docker_agent_templates[@]} ; do
    job_name="$(dirname ${docker_agent_template#./} | tr '/' '-')"
    ret=$(curl -s -o /dev/null -w "%{http_code}" -XGET "${url}/job/docker-${job_name}" -u "${user}:${token}")
    if [[ "${ret}" == "404" ]] ; then
      ret=$(curl -s -XPOST "${url}/createItem?name=docker-${job_name}" -u "${user}:${token}" --data-binary @"${docker_agent_template}" -H "${crumb}" -H 'Content-Type:text/xml')
      if [[ "${ret}" != "" ]] ; then
        echo "Failed to create docker agent template ${job_name}."
        echo "${ret}"
        exit 1
      else
        echo "Docker agent template ${job_name} created."
      fi
    else
      echo "Docker agent template ${job_name} already exists, ignoring."
    fi
  done

  return 0
}

function _parse_args() {
  for arg in "${@}" ; do
    case "${arg}" in
      -h|--help)
        _usage_main
        exit 0
        ;;
      -U|--url)
        if [[ ! -z ${2+x} && "${2}" != "" ]]; then
          __url="${2}"
          shift 2
        else
          echo "The ${1} parameter must be the URL to a Jenkins instance." 
          exit 1
        fi
        ;;
      -u|--user)
        if [[ ! -z ${2+x} && "${2}" != "" ]]; then
          __user="${2}"
          shift 2
        else
          echo "The ${1} parameter must be a Jenkins username." 
          exit 1
        fi
        ;;
      -t|--token)
        if [[ ! -z ${2+x} && "${2}" != "" ]]; then
          __token="${2}"
          shift 2
        else
          echo "The ${1} parameter must be a Jenkins user's API token." 
          exit 1
        fi
        ;;
      --) # End of all options
        shift
        break
        ;;
      -*)
        echo "Unknown option: ${1}"
        exit 1
        ;;
      *) # No more options
        break
        ;;
    esac
  done
  return 0
}

_main "${@}"
