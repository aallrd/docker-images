# git-hooks

A set of usefull git hooks to facilitate working on this project.

## Installation

Just run the `setup_git_hooks.sh` script to symlink the hooks in the .git/hooks directory.

## post-receive

This hook is ran after a `git push` on the remote server.

It's goal is to trigger the build of the Jenkins job `docker-images-seed-jobs` in order to reload the sub-project's DSLs and take into account any modification that was made to any sub-project.

It can also trigger a build of a specific sub-project if it detects that its files were modified.

**It is currently not installed on the Stash server and does nothing.**

**See the Automation section in the project's README."**
