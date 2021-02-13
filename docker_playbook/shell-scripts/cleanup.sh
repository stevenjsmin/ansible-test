#! /bin/bash

# The following two variables must be defined before the Playbook is executed.
#    - PLAYBOOK_BASE_DIR : Where the Playbook code will be checked out. If running on Jenkins, this is the equivalent of the "JENKINS_HOME/workspaces" directory.
#    - WORKING_DIR       : Where temporary files created during code execution will be stored. If they are run from Jenkins, this is the "WORKSPACE/BUILD_ID" directory.
PLAYBOOK_BASE_DIR="/NotBackedUp/Workspaces"
WORKING_DIR="/NotBackedUp/Workspaces/out"
# BUILD_VER="1.1.1"


# CLEANUP ALL TEMPORARY FILES THAT GENERATED DURING PIPELINE PROCESSING
# In case of failure, it will be ignore
#
# @param MODULE               : mandatory
# @param BUILD_VER            : Optional, if not given it will be set as '0.0.0'
# @param WORKING_DIR          : Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell
#
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/cleanup.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE='BPS' /
    BUILD_VER=${BUILD_VER} /
"