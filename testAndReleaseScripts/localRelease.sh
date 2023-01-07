#!/bin/bash

cd ..
configFile=./scriptConfig.sh
source $configFile

cd $projectPath
cd $projectName

cd android

fastlane beta

cd $scriptPath

./testAndReleaseScripts/uploadIosBuild.sh
