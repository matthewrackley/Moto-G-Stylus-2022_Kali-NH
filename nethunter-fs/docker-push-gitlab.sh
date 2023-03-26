#!/usr/bin/env sh

## Quit on error
set -e

## Variables
GIT_ACCOUNT=kalilinux
GIT_REPOSITORY=nethunter/build-scripts/kali-nethunter-project

## Move to folder
cd "$( dirname "$0" )"

## Local build
docker build -t nethunter .

## Remote build (GitLab.com)
docker build -t "registry.gitlab.com/${GIT_ACCOUNT}/${GIT_REPOSITORY}" .
docker push "registry.gitlab.com/${GIT_ACCOUNT}/${GIT_REPOSITORY}"

## Done
echo "[i] Done ~ https://gitlab.com/${GIT_ACCOUNT}/${GIT_REPOSITORY}/container_registry"
exit 0
