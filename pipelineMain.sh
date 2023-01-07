#!/bin/bash

#####################
#  This will
#
#       1) build the projects to make sure the builds are current with build numbers from pubspec.yaml and generated data

#       2) Use the screenshots package which runs flutter driver tests and also generates screenshots for usage with fastlane

#		3) Check for any errors before continuing

#       3) upload screenshots to ios

#        4) Run the associated build and deploys, Android on the GitLab Runner and iOS on CodeMagic (if you set the trigger there)
#
#
#####################################
#       USAGE
######################################
#
#       1)Increment the pubspec.yaml
#
#       2)Make sure the values indicated at the top of your /project/ios/fastlane/Fastfile are correct
#
#       3) Make sure your .gitlab-ci.yml is set to trigger the appropriate pipeline run according to the tag name and branch with "tags" and "only".
#			 The Tag will trigger the Gitlab Runner if it has the tag, and the branch will run the associated job according to "only"
#				https://docs.gitlab.com/ee/ci/yaml/

#       4) If you want, tell CodeMagic to trigger an iOS build when this branch is pushed
#
#   Check your branch with git log,  Then you're set to run
#
#      ./pipelineMain.sh 
#

configFile=scriptConfig.sh
source $configFile

set -e

cd $projectPath/$projectName

rm -f ./sstmp

# flutter build apk --release --target-platform android-arm64

flutter build apk

flutter build ios --release

#run the screenshots tests and save logs to sstmp


# Pipe std output and std error into a file
screenshots 2>&1 | tee  ./sstmp 

# check for errors and do not proceed with upload if anything goes wrong
 if cat ./sstmp | grep -q -i -E "Fail|Exit" ; then echo "Screen Shot encountered some error ... " && exit 1; else echo "All good"; fi 

 # move piped screenshot logs for future reference
mv -f ./sstmp ./ssLog

# clean up the simulator dameon. Pesky thing runs invisibly after everything is finished
ps aux | grep _sim | grep -v grep | awk '{print $2}' | xargs kill -9 2>/dev/null

cd ios

fastlane upload_screenshots


cd ..

# fastlane beta in Docker will upload android screenshots

# branch name will trigger the gitlab.ci.yml "only" parameter, so if you want to specify.. do a branch checkout
git add .
git commit -m "doin a new test"
git push
