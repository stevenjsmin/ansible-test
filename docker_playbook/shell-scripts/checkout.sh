#! /bin/bash

# The following two variables must be defined before the Playbook is executed.
#    - PLAYBOOK_BASE_DIR : Where the Playbook code will be checked out. If running on Jenkins, this is the equivalent of the "JENKINS_HOME/workspaces" directory.
#    - WORKING_DIR       : Where temporary files created during code execution will be stored. If they are run from Jenkins, this is the "WORKSPACE/BUILD_ID" directory.
PLAYBOOK_BASE_DIR="/NotBackedUp/Workspaces"
WORKING_DIR="/NotBackedUp/Workspaces/out"

GIT_CHECKOUT_BRANCH="feature/poc-for-upgrade-1.11"
GIT_REPO_NAME="ci_docker"

# CALL DEPENDENCY ROLES
./cleanup.sh


## ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Checkout Code from git repository
#
# @param GIT_REPO_NAME        : mandatory
# @param GIT_BASE_URL         : Optional, if empty it will use as base git "ssh://git@bitbucket.service.anz/cdp"
# @param GIT_CHECKOUT_BRANCH  : Optional, if not given it will be set as 'develop'
# @param WORKING_DIR          : Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell
#
##


ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/checkout.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    GIT_CHECKOUT_BRANCH="${GIT_CHECKOUT_BRANCH}" /
    GIT_REPO_NAME="${GIT_REPO_NAME}" /
"