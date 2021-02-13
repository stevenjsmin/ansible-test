#! /bin/bash

# The following two variables must be defined before the Playbook is executed.
#    - PLAYBOOK_BASE_DIR : Where the Playbook code will be checked out. If running on Jenkins, this is the equivalent of the "JENKINS_HOME/workspaces" directory.
#    - WORKING_DIR       : Where temporary files created during code execution will be stored. If they are run from Jenkins, this is the "WORKSPACE/BUILD_ID" directory.
PLAYBOOK_BASE_DIR="/NotBackedUp/Workspaces"
WORKING_DIR="/NotBackedUp/Workspaces/out"

## DESCRIPTION
# This is a Playbook that registers or downloads resources (files) stored in jFrog Artifact.
#
# PARAMS
# In the case of sub-directories, when uploading files, the relative path from the working directory must be specified, <br/>
# and in case of download, it means Sub-Group path of jFrog Artifactory.
#   @param ACTION - The mode of operation whether this Playbook will be used for download or upload.
#   @param FROM_ARTIFACT_NAME - Filename, including subdirectory
#   @param TO_ARTIFACT_NAME - Filename, including subdirectory


### Upload Artifact from jFrog Artifactory
#ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/artifactManage.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
#    ACTION="upload" /
#    FROM_ARTIFACT_NAME='/root/manifest1.yml' /
#    TO_ARTIFACT_NAME="bps-pco/manifest3.yml" /
#"

## Download Artifact from jFrog Artifactory
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/artifactManage.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    ACTION="download" /
    FROM_ARTIFACT_NAME='bps-pco/docker/runTime/20.02.20/dockerimage_BPS_20.02.20.yml' /
    TO_ARTIFACT_NAME="/NotBackedUp/Workspaces/out/dockerimage_BPS_20.02.20.yml" /
"