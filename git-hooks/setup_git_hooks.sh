#!/bin/bash
__git_root="$(git rev-parse --show-toplevel)"
__git_hooks="${__git_root}/.git/hooks"
__user_hooks="${__git_root}/git-hooks"
if [[ -d "${__git_hooks}" && -d "${__user_hooks}" ]] ; then
  cd "${__git_hooks}" || { echo "Failed to change directory to ${__git_hooks}" ; exit 1; }
  for user_hook in ${__user_hooks}/* ; do
    __hook="$(basename "${user_hook}")"
    if [[ "${__hook}" != "$(basename "${0}")" ]] ; then
      ln -s "${user_hook}" "${__hook}"
      if [[ $? -ne 0 ]] ; then
        echo "Failed to symlink ${user_hook} > ${__hook}"
      fi
    fi
  done
  cd "${OLDPWD}" || { echo "Failed to change back directory to ${OLDPWD}" ; exit 1; }
else
  echo "It seems that you are not executing this script in a git repository."
  exit 1
fi
