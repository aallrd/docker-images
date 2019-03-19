#!/usr/bin/env bash

source ~/utils.sh

function __usage_main() {
  __menu_lign
  __menu_header
  __menu_lign "[ OPTIONS ]"
  __menu_option "-h|--help" "Print this helper."
  __menu_option "-u|--user" "The Perforce user to login with. The login data is written in the mounted perforce-data volume." "${USERNAME:-username}"
  __menu_option "-v|--verify" "Print the Perforce data that can be read from the mounted perforce-data volume."
  __menu_lign
  __menu_footer
  __menu_lign
  exit 0
}

function __parse_args() {
  local values mandatory_args actions
  mandatory_args=(__user)
  for arg in "${@}" ; do
    case "${arg}" in
      -h|--help)
        __usage_main
        ;;
      -u|--user)
        if [[ -z ${2+x} || ${2} = "" ]] ; then
          __perror "The --user option is mandatory and cannot be an empty value."
          exit 1
        else
          __user="${2}"
          export P4USER="${__user}"
          shift 2
        fi
        ;;
      -v|--verify)
        __p4_verify
        ;;
      *) __parsed_args+=("${arg}")
    esac
  done
  for arg in "${mandatory_args[@]}" ; do if [[ -z ${!arg+x} ]] ; then echo "Mandatory option missing: [${arg}]" ; exit 1 ; fi ; done
  return 0
}

function __p4_verify() {
  if [[ ! -f ~/.p4tickets ]] ; then
    __pwarning "No .p4tickets file found in the mounted perforce-data volume."
  elif [[ -z ${P4USER+x} ]] ; then
    __pwarning "Use the --user option to set the P4USER variable."
  else
    __pinfo "$(p4 login -s)"
  fi
  exit 0
}

function __p4_clean() {
  rm -f ~/.p4config
  return 0
}

function __p4_login() {
  __pinfo "Loging using Perforce username: ${P4USER}"
  __pinfo "$(p4 login -s || p4 login)"
  echo "P4USER=${P4USER}" >> ~/.p4config
  return 0
}

function __p4_new_client() {
  local client
  client="docker-$(hostname)"
  p4 client -i <<EOF
Client: ${client}
Root:   /src/new
Options:    allwrite clobber nocompress unlocked modtime rmdir
SubmitOptions:  submitunchanged
LineEnd:    local
View:
    //depot/... //${client}/...
EOF
  echo "P4CLIENT=${client}" >> ~/.p4config
  return 0
}

function __main() {
  __parse_args "${@}"
  __p4_clean
  __p4_login
  __p4_new_client
}

__main "${@}"
