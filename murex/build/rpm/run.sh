#!/usr/bin/env bash

source /root/utils.sh

function __usage_main() {
  __menu_lign
  __menu_header
  __menu_lign "[ OPTIONS ]"
  __menu_option "-h|--help" "Print this helper."
  __menu_option "-b|--build" "Build the RPM from the spec file."
  __menu_option "--shell" "Open an interactive shell instead of calling the build script."
  __menu_lign
  __menu_footer
  __menu_lign
  exit 0
}

function __validate_requirements() {
  if [[ ! -d /specs ]] ; then
    __perror "The /specs directory is not mounted in the container."
    __pwarning "You must use the --volume specs:/specs option when starting the container."
    return 1
  elif [[ $(\ls /specs/*.spec | wc -l) -eq 0 ]] ; then
    __perror "The mounted /specs directory does not contain a .spec file."
    return 1
  elif [[ $(\ls /specs/*.spec | wc -l) -gt 1 ]] ; then
    __perror "The mounted /specs directory contains more than one .spec file."
    return 1
  elif [[ ! -d /output ]] ; then
    __perror "The /output directory is not mounted in the container."
    __pwarning "You must use the --volume output:/output option when starting the container."
    return 1
  fi
  __spec_file="$(\ls /specs/*.spec | xargs basename)"
  if [[ ${__spec_file} == "" ]] ; then
    __perror "Failed to parse the mounted spec file name."
    return 1
  else
    __pinfo "RPM spec file: ${__spec_file}"
  fi 
  return 0
}

function __list_rpm() {
  __rpms=($(\ls /root/rpmbuild/RPMS/*/*rpm))
  if [[ ${#__rpms[@]} -eq 0 ]] ; then
    __perror "No binary RPM files found in the rpmbuild/RPMS directory."
    return 1
  else
    __psuccess "Binary RPM file(s):"
    for rpm in ${__rpms[@]} ; do
      __psuccess "* ${rpm}"
      cp "${rpm}" /output
    done
  fi
  __srpms=($(\ls /root/rpmbuild/SRPMS/*rpm))
  if [[ ${#__srpms[@]} -eq 0 ]] ; then
    __perror "No source RPM files found in the rpmbuild/SRPMS directory."
    return 1
  else
    __psuccess "Source RPM file(s):"
    for srpm in ${__srpms[@]} ; do
      __psuccess "* ${srpm}"
      cp "${srpm}" /output
    done
  fi
  return 0
}

function __build_rpm() {
  rpmdev-setuptree || {
    __perror "Failed to setup the RPM build tree.";
    return 1;
  }
  cp "/specs/${__spec_file}" /root/rpmbuild/SPECS/ || {
    __perror "Failed to copy the spec file /specs/${__spec_file} to /root/rpmbuild/SPECS/";
    return 1;
  }
  spectool -C /root/rpmbuild/SOURCES -g "/root/rpmbuild/SPECS/${__spec_file}" || {
    __perror "Failed to download the sources using spectool.";
    return 1;
  }
  rpmbuild -v -ba "/root/rpmbuild/SPECS/${__spec_file}" || {
    __perror "Failed to build the RPM files.";
    return 1;
  }
  return 0
}

function __parse_args() {
  local values mandatory_args actions
  mandatory_args=()
  for arg in "${@}" ; do
    case "${arg}" in
      -h|--help)
        __usage_main
        ;;
      --shell)
        exec bash -l
        ;;
      *) __parsed_args+=("${arg}")
    esac
  done
  for arg in "${mandatory_args[@]}" ; do if [[ -z ${!arg+x} ]] ; then echo "Mandatory option missing: [${arg}]" ; exit 1 ; fi ; done
  return 0
}

function __main() {
  __parse_args "${@}"
  __validate_requirements || { return 1; }
  __build_rpm || { return 1; }
  __list_rpm || { return 1; }
  return 0
}

__main "${@}"

