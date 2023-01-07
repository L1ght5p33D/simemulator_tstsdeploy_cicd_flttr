#!/bin/bash

curpath=$(echo $PWD)
cd ..
configFile=scriptConfig.sh
releaseConfig=testAndReleaseScripts/releaseConfig.sh
    source $releaseConfig
    source $configFile

projectDir=$projectPath/$projectName

cd $projectDir/ios/Runner

#parseVersionString="$(gsed -n '/<key>CFBundleVersion<\/key>/,/<\/string>/p' ./Info.plist)"
#gotVersionString="$(echo $parseVersionString | sed 's/.*<string>\(.*\)<\/string>/\1/')"

#incVersion="$(($gotVersionString + 1))"

#androidVersionNameAndNo=$buildName"+"$incVersion

#androidVersionNameAndNo=$buildName"+"$buildNumber

cd $projectDir

flutter build ios --release

#gsed -i -e "s/version:.*/version: ${androidVersionNameAndNo}/" ./pubspec.yaml

cd $projectDir/ios

#increment the build number and set build name
#agvtool new-marketing-version $buildName
#agvtool next-version -all

cd $projectDir/android

echo $releaseNotes > ./fastlane/metadata/android/en-US/release_notes.txt
echo $releaseNotes > $projectDir/ios/fastlane/metadata/en-US/release_notes.txt

cd $projectDir
flutter clean
git add .
git commit -m "${commitMessage}"
git push

