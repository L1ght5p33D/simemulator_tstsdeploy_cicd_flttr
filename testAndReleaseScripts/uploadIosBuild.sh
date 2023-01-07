#!/bin/bash

#if you have to find signing cert hashes you can use
#security find-identity -v -p codesigning
#along with a downloaded profile/cert from app store connect and set in exportOptions.plist

#be sure dev account does not have 2 factor auth enabled or else make a dev sub account in
#https://appstoreconnect.apple.com/access/users

#fill out the iosExportOptions as necessary
#The Provisioning Profile key is in parenthases in App ID in the App Store Connect provisioning profile display. The string is  in Name
#The string for the signing certificate in iosExportOptions is the SHA-1, you can list them by running "security find-identity -v -p codesigning", To know which one is correct go to xCode under the provisioning profile, and download that cert from App store connect, open (with keychain default ), match the expiration date? (might be a better way)...  right click > get info and the SHA-1 is at the very bottom. There is no other way i know how to do this... there is no consistent obvious name or id associated with the certificates. :(

configFile=../scriptConfig.sh
source $configFile

releaseConfig=$PWD/releaseConfig.sh
source $releaseConfig

buildScriptPath=$(echo $PWD)

projectDir=$projectPath/$projectName

cd $projectDir

flutter build ios

buildPath=$projectDir/ios

cd $buildPath

#set the build name from releaseconfig
agvtool new-marketing-version $buildName

#increment the build version.
agvtool next-version -all

mkdir build

xcodebuild -workspace $buildPath/Runner.xcworkspace -scheme Runner -destination generic/platform=iOS build


xcodebuild -workspace $buildPath/Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration AppStoreDistribution archive -archivePath $buildPath/build/Runner.xcarchive


xcodebuild -exportArchive -archivePath $buildPath/build/Runner.xcarchive -exportOptionsPlist $buildScriptPath/iosExportOptions.plist -exportPath $buildPath/build

cd build

/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool --upload-app -f $buildPath/build/Runner.ipa -u $itunesConnectId -p $appSpecificPass

