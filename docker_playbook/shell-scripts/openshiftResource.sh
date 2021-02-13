#! /bin/bash

# The following two variables must be defined before the Playbook is executed.
#    - PLAYBOOK_BASE_DIR : Where the Playbook code will be checked out. If running on Jenkins, this is the equivalent of the "JENKINS_HOME/workspaces" directory.
#    - WORKING_DIR       : Where temporary files created during code execution will be stored. If they are run from Jenkins, this is the "WORKSPACE/BUILD_ID" directory.
PLAYBOOK_BASE_DIR="/NotBackedUp/Workspaces"
WORKING_DIR="/NotBackedUp/Workspaces/out"

## For bps
DOCKER_VER="20.03.22"
MODULE="OpenAM"

## For Connectivity
#DOCKER_VER="20.02.29"
#MODULE="CONNECTIVITY"

## DESCRIPTION
# Managing OpenShift resources such as create, update, delete for ImageStream, Service, Route and DeploymentConfig
#
# PARAMS
#   @param CMD_TYPE - Operation type [build:default | remove ]
#   @param OP_RSC_TYPE - OpenShift resource type [imageStream | service | route | deploymentConfig ]
#   @param MODULE - [BPS | CONNECTIVITY | WEB-ENGINE ]
#   @param DOCKER_VER
#   @param WORKING_DIR - Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell

## Create Openshisft "imageStream" resource
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE="${MODULE}" /
    DOCKER_VER="${DOCKER_VER}" /
    OP_RSC_TYPE='imageStream' /
"

### Create Openshisft "service" resource
#ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
#    WORKING_DIR="${WORKING_DIR}" /
#    MODULE="${MODULE}" /
#    DOCKER_VER="${DOCKER_VER}" /
#    OP_RSC_TYPE='service' /
#"
#
### Create Openshisft "route" resource
#ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
#    WORKING_DIR="${WORKING_DIR}" /
#    MODULE="${MODULE}" /
#    DOCKER_VER="${DOCKER_VER}" /
#    OP_RSC_TYPE='route' /
#"
#
### Create Openshisft "deploymentConfig" resource
#ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
#    WORKING_DIR="${WORKING_DIR}" /
#    MODULE="${MODULE}" /
#    DOCKER_VER="${DOCKER_VER}" /
#    OP_RSC_TYPE='deploymentConfig' /
#"

## Delete all Openshisft resource regarding given module
#ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
#    WORKING_DIR="${WORKING_DIR}" /
#    MODULE="${MODULE}" /
#    CMD_TYPE='remove' /
#"