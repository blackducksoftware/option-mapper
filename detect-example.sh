#!/bin/bash
# 
# Example script that utilizes option-mapper to map multiple --detect.source.path options onto multiple 
# invocations of detect script.
#
# see OPTION and TARGET variables in option-mapper.sh
# 
# OPT_DEPEND defines dependent options as:
#  detect.code.location.name
#  detect.bom.aggregate.name
#


PROJECT=$1
VERSION=$2

if [ "$PROJECT" = "" ]
then
  PROJECT=$(pwd)
fi

if [ "$VERSION" = "" ]
then
  VERSION=LATEST
fi

export SPRING_APPLICATION_JSON='{"blackduck.url":"https://your-blackduck-host","blackduck.api.token":"place API token here"}'
bash option-mapper.sh \
     --detect.source.path=workspace/hub-rest-api-python  \
     --detect.source.path=workspace/kegbot-docker \
     --blackduck.trust.cert=true \
     --detect.project.name=${PROJECT} \
     --detect.python.python3=true \
     --detect.pip.requirements.path=`pwd`/requirements.txt \
     --detect.project.version.name=${VERSION} \
     --detect.code.location.name=${PROJECT}_${VERSION}_code \
     --detect.bom.aggregate.name=${PROJECT}_${VERSION}_PKG \
