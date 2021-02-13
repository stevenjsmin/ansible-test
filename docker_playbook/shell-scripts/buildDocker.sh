#! /bin/bash

# The following two variables must be defined before the Playbook is executed.
#    - PLAYBOOK_BASE_DIR : Where the Playbook code will be checked out. If running on Jenkins, this is the equivalent of the "JENKINS_HOME/workspaces" directory.
#    - WORKING_DIR       : Where temporary files created during code execution will be stored. If they are run from Jenkins, this is the "WORKSPACE/BUILD_ID" directory.
PLAYBOOK_BASE_DIR="/NotBackedUp/Workspaces"
WORKING_DIR="/NotBackedUp/Workspaces/out"

MODULE="BPS"
GIT_CHECKOUT_BRANCH="feature/poc-for-upgrade-1.11"
DOCKERFILE="Dockerfile-pco"

# CALL DEPENDENCY ROLES
./cleanup.sh
./checkout.sh

## ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## DESCRIPTION
# Bake docker image
#     Note: BUILD_VER that given as parameter will be used for Docker image version tag
#
# PARAMS
#   @param MODULE                   : mandatory
#   @param BUILD_VER                : Optional, if not given it will be set as "0.0.0"
#   @param DOCKERFILE               : Optional, if not given it will be set as "Dockerfile"
#   @param ARTIFACT_REPO_URL        : Optional, if not given it will be set as "artifactory.service.anz:8021/cdp-poc"
#   @param MODULE_TYPE              : Optional, if not given it will be set as "pco"
#   @param CREATE_LATEST_TAG        : Optional, if not given it will be set as "no"
#   @param DOCKER_IMG_PUSH          : Optional, if not given it will be set as "no"
#   @param GIT_CHECKOUT_BRANCH      : Optional, if not given it will be set as "develop"
#   @param ACTION                   : Optional, if not given it will be set as "build". if set as "delete" then it will try to remove the Docker image from local
#   @param WORKING_DIR              : Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell
#


# BPS
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/buildDocker.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE='${MODULE}'                                 /
    BUILD_VER=${BUILD_VER}                             /
    MODULE_TYPE=pco                                    /
    DOCKER_IMG_PUSH=yes                                /
    GIT_CHECKOUT_BRANCH=${GIT_CHECKOUT_BRANCH}         /
    DOCKERFILE=${DOCKERFILE}                           /
"

# BPS Delete
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/buildDocker.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE='${MODULE}                                  /
    BUILD_VER=${BUILD_VER}                             /
    MODULE_TYPE=pco                                    /
    ACTION=delete                                      /
"


# CONNECTIVITY
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/buildDocker.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}"                       /
    MODULE='CONNECTIVITY'                              /
    BUILD_VER=${BUILD_VER}                             /
    MODULE_TYPE=pco                                    /
    DOCKER_IMG_PUSH=yes                                /
    GIT_CHECKOUT_BRANCH=${GIT_CHECKOUT_BRANCH}         /
    DOCKERFILE=${DOCKERFILE}                           /
"


# Cleanup temporary files
#./cleanup.sh
