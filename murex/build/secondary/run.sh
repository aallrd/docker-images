#!/usr/bin/env bash

source /etc/profile
source ~/utils.sh

export P4CONFIG=~/.p4config

function __usage_main() {
  __menu_lign
  __menu_header
  __menu_lign "[ OPTIONS ]"
  __menu_option "-h|--help" "Print this helper."
  __menu_option "-v|--version" "The targeted version to build." "v3.1.build"
  __menu_option "-c|--changelist" "The Perforce changelist to synchronize for the targeted version. Default is HEAD." "1234567"
  __menu_option "--no-sync" "Don't sync the targeted version sources. The source volume shoud already contain the synced sources. Useful when mounting the host filesystem."
  __menu_option "--git" "Use Bitbucket instead of Perforce to sync the targeted version sources. Expects the project name where the version (repo) is stored." "INFRA"
  __menu_option "--shell" "Open an interactive shell instead of calling the build script."
  __menu_option "--" "The arguments passed after this delimiter are evaluated by the targeted version build script." "-- --help"
  __menu_lign
  __menu_footer
  __menu_lign
  exit 0
}

function __parse_args() {
  local values mandatory_args actions
  mandatory_args=(__version)
  __changelist="#head"
  __sync=${__sync:-true}
  __shell=${__shell:-false}
  __git=${__git:-false}
  for arg in "${@}" ; do
    case "${arg}" in
      -h|--help)
        __usage_main
        exit 0
        ;;
      -v|--version)
        __version="${2:?No targeted version specified on the command line.}"
        shift 2
        ;;
      -c|--changelist)
        __changelist="@${2:?No changelist specified on the command line.}"
        shift 2
        ;;
      --no-sync)
        __sync=false
        shift 1
        ;;
      --git)
        __git=true
        __repo="${2:?No Bitbucket project specified on the command line.}"
        shift 2
        ;;
      --shell)
        __shell=true
        shift 1
        ;;
       --)
        shift 1
        __build_script_args=(${@})
        break
        ;;
      *) __parsed_args+=("${arg}")
    esac
  done
  for arg in "${mandatory_args[@]}" ; do if [[ -z ${!arg+x} ]] ; then __perror "Mandatory option missing: [${arg}]" ; exit 1 ; fi ; done
  if [[ -z ${__version+x} || ${__version} == "" ]] ; then
    echo "The --version argument is mandatory and cannot be an empty value." ; exit 1 ;
  fi
  return 0
}

function __validate_source_volume() {
  local versions
  versions=($(\ls -d /src/new/* 2>/dev/null| sed 's#/src/new/##' | xargs))
  if [[ ${#versions[@]} -eq 1 ]] ; then
    if [[ "${__version}" != "${versions[0]}" ]] ; then
      __perror "The targeted version [${__version}] was not found synced. Found instead: ${versions[0]}"
      exit 1
    fi
  elif [[ ${#versions[@]} -gt 1 ]] ; then
      __pwarning "Multiple versions are already synced in the mounted source volume: ${versions[*]}"
  fi
  return 0
}

function __sync_version() {
  local ret
  if [[ ${__git} == true ]] ; then
    if [[ ! -d ${__version} ]] ; then
      __pinfo "Cloning [https://bitbucket.local/scm/${__repo}/${__version}.git]"
      git clone "https://bitbucket.local/scm/${__repo}/${__version}.git"
      if [[ ${?} -ne 0 ]] ; then
        __perror "An error occured while cloning the version: ${__version}" ; exit 1 ;
      fi
    else
      cd "${__version}" 2>/dev/null || { __perror "Failed to change directory to: ${__version}"; exit 1; }
      __pinfo "Pulling master [https://bitbucket.local/scm/${__repo}/${__version}.git]"
      git pull
      if [[ ${?} -ne 0 ]] ; then
        __perror "An error occured while pulling the latest changes for the version: ${__version}" ; exit 1 ;
      fi
    fi
  else
    if [[ ! -f ~/.p4config ]] ; then
        __perror "No Perforce configuration information found in the mounted perforce-data volume." ; exit 1 ;
    fi
    __pinfo "Syncing Perforce [//depot/${__version}/...${__changelist}]"
    p4 sync -qf --parallel=6 "//depot/${__version}/...${__changelist}" || {
      __perror "An error occured while synchronizing the version: ${__version} (${__changelist})" ; exit 1 ;
    }
  fi
  if [[ ! -d "/src/new/${__version}" ]] ; then
    __perror "Failed to synchronise the version: ${__version} (${__changelist})" ; exit 1 ;
  fi
  return 0
}

function __open_build_shell() {
  local internal_version_environment
  internal_version_environment=~/.internal_version_environment
  cat <<EOF > "${internal_version_environment}"
cd /src/new/${__version}
source build/settings.sh
EOF
  echo "source ${internal_version_environment}" >> ~/.bash_profile
  exec bash -l
}

function __build_secondary() {
  __build_scripts_dir="/src/new/${__version}/build/onyx"
  cd "${__build_scripts_dir}" 2>/dev/null || { __perror "Failed to change directory to: ${__build_scripts_dir}"; exit 1; }
  __pinfo "Calling build_secondary.sh: ${__build_script_args[*]:-(no options)}"
  exec ./build_secondary.sh ${__build_script_args[@]:-}
}

function __main() {
  __parse_args "${@}"
  __validate_source_volume
  if [[ ${__shell} == true ]] ; then
    __open_build_shell
  fi
  if [[ ${__sync} == true ]] ; then
    __sync_version
  fi
  __build_secondary
}

__main "${@}"
