IMPLEMENTED ANSIBLE PLAYBOOK CDP APIS
======================
Welcome ! This Ansible playbook collections for CDP APP appliction CI.CD<br/><br/>

**Related sites**<br/>
Project Confluence page : https://confluence.service.anz/pages/viewpage.action?pageId=549072839 <br/>
CDP Jenkins : http://jenkins-cdp-poc-cdp-environment-blue.apps.cpaas.service.test/ <br/>
<br/>

<hr>

## PRECONDITION
**This is not the case when running in a Jenkins pipeline.**<br/>
The following two variables must be defined before the Playbook is executed.<br/>
   - **PLAYBOOK_BASE_DIR** : Where the Playbook code will be checked out. If running on Jenkins, this is the equivalent of the "JENKINS_HOME/workspaces" directory.<br/>
   - **WORKING_DIR**       : Where temporary files created during code execution will be stored. If they are run from Jenkins, this is the "WORKSPACE/BUILD_ID" directory.<br/>
   
***Example***
```shell script
$> export PLAYBOOK_BASE_DIR="/NotBackedUp/Workspaces"
$> export WORKING_DIR="/NotBackedUp/Workspaces/out"
```   
<hr>

## VARIABLES
Playbook execution is designed to depend on many variables to separate execution code and execution condition.<br/> 
Therefore, the execution and editing of Playbook code should be used according to the design intention of this variable dependency to help maintain the consistency of the code.<br/>
<br/>
The variable areas associated with Playbooks are as follows:<br/>
- **JENKINS**<br/>
- **INVENTORY :: COMMON**<br/>
- **INVENTORY :: MODULE SPECIFIC**<br/>
- **ANSIBLE PLAYBOOK ROLE :: COMMON**<br/>
- **ANSIBLE PLAYBOOK ROLE :: ROLE SPECIFIC**<br/>
<br/>
See the following Confluence page for more details. : https://confluence.service.anz/display/CUP/Ansible 
<hr>

## ARTIFACT MANAGEMENT
PLAYBOOK : **artifactManage.yml** <br/>

**DESCRIPTION**<br/>
This is a Playbook that registers or downloads resources (files) stored in jFrog Artifact.<br/>
<br/>
**PARAMS**<br/>
In the case of sub-directories, when uploading files, the relative path from the working directory must be specified, <br/>
and in case of download, it means Sub-Group path of jFrog Artifactory.<br/>
-  **@param ACTION** - The mode of operation whether this Playbook will be used for download or upload.<br/>
-  **@param FROM_ARTIFACT_NAME** - Filename, including subdirectory<br/>
-  **@param TO_ARTIFACT_NAME** - Filename, including subdirectory<br/>

***Example***
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/artifactManage.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    ACTION="download"  /
    FROM_ARTIFACT_NAME='bps-pco/docker/runTime/20.02.20/dockerimage_BPS_20.02.20.yml' /
    TO_ARTIFACT_NAME="/NotBackedUp/Workspaces/out/dockerimage_BPS_20.02.20.yml"       /
"
```
<br/>
<hr>



## DOCKER BUILD
PLAYBOOK : **buildDocker.yml** 

**DESCRIPTION**<br/>
Bake docker image<br/>
    ***Note: BUILD_VER that given as parameter will be used for Docker image version tag***<br/>
<br/>
**PARAMS**<br/>
-  **@param MODULE**                   - mandatory<br/>
-  **@param BUILD_VER**                - Optional, if not given it will be set as "0.0.0"<br/>
-  **@param DOCKERFILE**               - Optional, if not given it will be set as "Dockerfile"<br/>
-  **@param ARTIFACT_REPO_URL**        - Optional, if not given it will be set as "artifactory.service.anz:8021/cdp-poc"<br/>
-  **@param MODULE_TYPE**              - Optional, if not given it will be set as "pco"<br/>
-  **@param CREATE_LATEST_TAG**        - Optional, if not given it will be set as "no"<br/>
-  **@param DOCKER_IMG_PUSH**          - Optional, if not given it will be set as "no"<br/>
-  **@param GIT_CHECKOUT_BRANCH**      - Optional, if not given it will be set as "develop"<br/>
-  **@param ACTION**                   - Optional, if not given it will be set as "build". if set as "delete" then it will try to remove the Docker image from local<br/>
-  **@param WORKING_DIR**              - Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell<br/>  
  
 
***Example*** - Docker build for BPS module
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/buildDocker.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE='BPS'                                       /
    BUILD_VER=${BUILD_VER}                             /
    MODULE_TYPE=pco                                    /
    DOCKER_IMG_PUSH=yes                                /
    GIT_CHECKOUT_BRANCH='feature/poc-for-upgrade-1.11' /
    DOCKERFILE=Dockerfile-pco                          /
"
```

***Example*** - Docker build for CONNECTIVITY module
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/buildDocker.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}"                       /
    MODULE='CONNECTIVITY'                              /
    BUILD_VER=${BUILD_VER}                             /
    MODULE_TYPE=pco                                    /
    DOCKER_IMG_PUSH=yes                                /
    GIT_CHECKOUT_BRANCH='feature/poc-for-upgrade-1.11' /
    DOCKERFILE=Dockerfile                              /
"
```

***Example*** - Docker delete on local<br/>
We can use it, we we need to delete docker image on the local machine that used for Docker image create
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/buildDocker.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE='BPS'                                       /
    BUILD_VER=${BUILD_VER}                             /
    MODULE_TYPE=pco                                    /
    ACTION=delete                                      /
"
```

<br/>
<hr>


## OPENSHIFT RESOURCE
PLAYBOOK : **openshiftResource.yml** 

**DESCRIPTION**<br/>
Managing OpenShift resources such as create, update, delete for ImageStream, Service, Route and DeploymentConfig
<br/>
**PARAMS**<br/>
- **@param CMD_TYPE** - Operation type [build:default | remove ]
- **@param OP_RSC_TYPE** - OpenShift resource type [imageStream | service | route | deploymentConfig ]
- **@param MODULE** - [BPS | CONNECTIVITY | WEB-ENGINE ]
- **@param DOCKER_VER**
- **@param WORKING_DIR** - Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell

***Example*** - Create Openshisft "imageStream" resource<br/>
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE="${MODULE}"           /
    DOCKER_VER="${DOCKER_VER}"   /
    OP_RSC_TYPE='imageStream'    /
"
```

***Example*** - Create Openshisft "service" resource<br/>
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE="${MODULE}"           /
    DOCKER_VER="${DOCKER_VER}"   /
    OP_RSC_TYPE='service'        /
"
```

***Example*** - Create Openshisft "route" resource<br/>
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE="${MODULE}" /
    DOCKER_VER="${DOCKER_VER}" /
    OP_RSC_TYPE='route' /
"
```

***Example*** - Create Openshisft "deploymentConfig" resource<br/>
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}"   /
    MODULE="${MODULE}"             /
    DOCKER_VER="${DOCKER_VER}"     /
    OP_RSC_TYPE='deploymentConfig' /
"
```

***Example*** - Delete all Openshisft resource regarding given module<br/>
Used to delete all Openshift resources that depend on a specific module(application).<br/>
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/openshiftResource.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}" /
    MODULE="${MODULE}"           /
    CMD_TYPE='remove'            /
"
```

<br/>
<hr>



## CLEAN-UP
PLAYBOOK : **cleanup.yml**<br/>

Call to clean up temporary directory or files that produced while pipeline process. <br/>
You can call it before start pipeline process or before. In case of failure, it will be ignore.<br/> 
<br/>
**PARAMS**<br/>
- **@param MODULE**               - mandatory<br/>
- **@param BUILD_VER**            - Optional, if not given it will be set as '0.0.0'<br/>
- **@param WORKING_DIR**          - Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell<br/>
<br/>
<hr>



## CHECKOUT
PLAYBOOK : **checkout.yml**<br/>
 
Checkout Code from git repository<br/>
<br/>
**PARAMS**<br/>
-  **@param GIT_REPO_NAME**        - mandatory<br/>
-  **@param GIT_BASE_URL**         - Optional, if empty it will use as base git "ssh://git@bitbucket.service.anz/cdp"<br/>
-  **@param GIT_CHECKOUT_BRANCH**  - Optional, if not given it will be set as 'develop'<br/>
-  **@param WORKING_DIR**          - Optional, you don't neet to set when you run it on Jenkins but please set it when you run on Shell<br/>

***Example***<br/>
```shell script
ansible-playbook -vv ${PLAYBOOK_BASE_DIR}/ci_playbooks/checkout.yml -i ${PLAYBOOK_BASE_DIR}/ci_playbooks/inventory/hosts --extra-vars " /
    WORKING_DIR="${WORKING_DIR}"        /
    GIT_CHECKOUT_BRANCH='feature/poc-for-upgrade-1.11' /
    GIT_REPO_NAME='ci_docker'           /
"
```


<hr>
<br/>


..... TO BE CONTINUED