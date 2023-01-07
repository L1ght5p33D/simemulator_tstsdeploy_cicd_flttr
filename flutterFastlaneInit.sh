#!/bin/bash

#get config variables
configFile=$PWD/scriptConfig.sh
source $configFile

export scriptPath

# exit script if any commands fail with exit code
set -e

echo "When flutter says " "All done!" " the script has not finished... just wait for your command prompt to return or enter any prompted information"
    sleep 5

mkdir -p $projectPath

#create flutter project
cd $projectPath
flutter create --org $packageOrganization --description "${projectDesc}" $projectName

projectDir=$projectPath/$projectName

#create the flutter driver test setup
#testing flutter code ref ::: https://flutter.dev/docs/cookbook/testing/integration/introduction
cd $projectDir/lib
    rm ./main.dart
    cp -f $scriptPath/templates/flutterTest/testCounterApp.dart ./main.dart

cd $projectDir

# add test dependency and project name
    export projectName projectDesc
    cat $scriptPath/templates/flutterTest/pubspec.yaml | envsubst  > ./pubspec.yaml

    mkdir test_driver
    cd test_driver

        cat $scriptPath/templates/flutterTest/app.dart | envsubst  > ./app.dart
        cp $scriptPath/templates/flutterTest/app_test.dart ./

cd $projectDir
    cp $scriptPath/templates/fastlaneFiles/GemfileTemplate ./Gemfile
    echo "gem 'pry'" >> ./Gemfile
    sudo bundle install

#comment out version for fastlane auto versioning in pubspec.yaml
#    sed -i "" -e 's/version:/#version:/' ./pubspec.yaml

#initialize as git repo and checkout branch named in config
    git init
    git checkout -b $gitBranchName


flutterRoot='$flutterRoot'
    export androidAppPackageName flutterRoot
        cat $scriptPath/templates/flutterBuild/buildGradleTemplate | envsubst  > $projectPath/$projectName/android/app/build.gradle
    export -n flutterRoot
#could just do this instead of the previous step to not change the signing config
#sed -i "" -e "s/\"com.example.$projectName\"/\"${androidAppPackageName}\"/" ./build.gradle

cd $projectDir

#create keys with values from config including passphrases in the local project
if [ "${createNewAndroidKeystore}" = "yes" ]; then
    cd android/app
        $scriptPath/androidKeyGen.sh
        cp ./key.jks $scriptPath/generated/androidKeyCopy.jks



    cd $projectDir/android
        export androidKeyStorePass androidKeyPass androidKeyAlias androidKeyStorePath
            cat $scriptPath/templates/keyFiles/androidKeyPropertiesTemplate | envsubst  > $scriptPath/generated/keyPropertiesGen
            yes | cp -f $scriptPath/generated/keyPropertiesGen ./key.properties

#do not upload the key properties to public repo.
#Codemagic will generate and populate the key.properties file during the build based on the input you provide in their UI.
#Fastlane builds will use the encrypted files with an enviroment variable set to the encryption password

    cd $projectDir

        openssl enc -aes-256-cbc -salt -in android/app/key.jks -out android/app/key.jks.enc -k $androidKeyEncryptPass
        openssl enc -aes-256-cbc -salt -in android/key.properties -out android/key.properties.enc -k $androidKeyEncryptPass


        echo "**/android/app/key.jks" >> ./.gitignore
        echo "**/android/key.properties" >> ./.gitignore


    else
        echo "Remember to add your keystore config to the project later"
    fi


    yes | cp -f $scriptPath/templates/flutterTest/screenshotsYamlTemplate $projectDir/screenshots.yaml

cd $projectDir/android

mkdir fastlane

echo "package_name(\"${androidAppPackageName}\") # Android Package Name e.g. com.example.app" > $projectDir/android/fastlane/Appfile
echo "json_key_data_raw(ENV['GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE'])" >> $projectDir/android/fastlane/Appfile

    yes | cp -f $scriptPath/templates/fastlaneFiles/androidFastfileTemplate $projectDir/android/fastlane/Fastfile

mkdir -p $projectDir/android/fastlane/metadata/android/en-US/
mkdir -p $projectDir/ios/fastlane/metadata/en-US/
echo "no releases yet" > $projectDir/android/fastlane/metadata/android/en-US/release_notes.txt
echo "no releases yet" > $projectDir/ios/fastlane/metadata/en-US/release_notes.txt

cd $projectDir/android/app/src/main

    sed -i "" -e "s/\"com.example.${projectName}\"/\"${androidAppPackageName}\"/" ./AndroidManifest.xml

    sed -i "" -e "s/android:label=\"${projectName}\"/android:label=\"${appName}\"/" ./AndroidManifest.xml

cd $projectDir/android/app/src/debug
    sed -i "" -e "s/\"com.example.${projectName}\"/\"${androidAppPackageName}\"/" ./AndroidManifest.xml
cd $projectDir/android/app/src/profile
    sed -i "" -e "s/\"com.example.${projectName}\"/\"${androidAppPackageName}\"/" ./AndroidManifest.xml

cd $projectDir/ios/Runner.xcodeproj
# Xcode does some weird parsing to the project name to come up with a temporary default bundle ID. could do some more intricate regExp to avoid having to set bundle id in xcode later.. something like the following
#but will just set after in xcode for now
#gsed -i -e "s/PRODUCT_BUNDLE_IDENTIFIER = com.example.${projectName};/PRODUCT_BUNDLE_IDENTIFIER = ${iosAppIdentifier};/gI" ./project.pbxproj


cd $projectDir/ios/fastlane


    export iosAppIdentifier appleEmail developerPortalTeamId itunesConnectId itunesConnectTeamId
        cat $scriptPath/templates/fastlaneFiles/iosAppfileTemplate | envsubst  > $scriptPath/generated/builtIosAppfile
            yes | cp -f $scriptPath/generated/builtIosAppfile ./Appfile


    export flMatchRepoUrl iosProvisionType
        cat $scriptPath/templates/fastlaneFiles/iosMatchFileTemplate  | envsubst  > $scriptPath/generated/builtIosMatchfile
            yes | cp -f $scriptPath/generated/builtIosMatchfile ./Matchfile


        # cat $scriptPath/templates/fastlaneFiles/iosFastfileTemplate  | envsubst  > $scriptPath/generated/builtIosFastfile
        #     yes | cp -f $scriptPath/generated/builtIosFastfile ./Fastfile
        
       yes | cp -f $scriptPath/templates/fastlaneFiles/iosFastfileTemplate  ./Fastfile

cd $projectDir
    yes | cp -f $scriptPath/templates/fastlaneFiles/gitlabCIymlTemplate ./.gitlab-ci.yml

echo '.gitlab-ci.yml' >> .gitignore

mkdir fastlane
    yes | cp -f $scriptPath/templates/fastlaneFiles/fastlaneCommonTemplate ./fastlane/Fastlane.common


cd $projectDir/android
    cp $scriptPath/templates/fastlaneFiles/GemfileTemplate ./Gemfile
    cp $scriptPath/templates/flutterBuild/docker.local.propertiesTemplate ./docker.local.properties

cd $projectDir/ios
    cp $scriptPath/templates/fastlaneFiles/GemfileTemplate ./Gemfile

cd $projectDir

    git add .
    git commit -m "inital commit for auto created fastlane flutter project"


if [ "${addGitLabSSLKey}" = "yes" ]; then
    cd ~/
    publicSSHKey="$(cat ./.ssh/id_rsa.pub)"
        echo "add the following ssh public key to your gitlab repo ::: "
        echo $publicGitlabSSHKey
    read -p "after you have added the public key, press enter to continue setup"
    fi

cd $projectDir/ios

#create the app on App Store Connect
#more options https://docs.fastlane.tools/actions/produce/
    fastlane produce -u $appleEmail -a $iosAppIdentifier -q "${appName}"

#create the signing certificate and store in GitLab Match profile repo so your team can share
#the cert. Ironically.. you can not release a testflight build with a development cert , so we use appstore cert

if [ "${useMatch}" = true ]; then
    fastlane match --verbose --username $appleEmail --keychain_password $applePass --git_url $flMatchRepoUrl --app_identifier $iosAppIdentifier --type $iosProvisionType
else
    if [ "${iosCertType}" = "distribution" ]; then
        forceDev=false
    else
        forceDev=true
    fi

fastlane cert --development $forcedev --username $appleEmail --keychain_password $applePass --team_id $developerPortalTeamId --output_path ./generated

fastlane sigh --username $appleEmail --app_identifier $iosAppIdentifier --team_id $developerPortalTeamId --provisioning_name "${provisionName}" --cert_id $certIdToUse --output_path ./generated --development $forceDev --force true --adhoc $makeAdHocProfile
fi

#cd fastlane
#you may want to delete this as it contains secure personal user info. At least move it out of the project directory and do not add to source control
#    mv ./Matchfile $FASTLANE_PROJECT_INIT_PATH/generated/builtMatchfile
cd $projectDir
    echo "/ios/fastlane/Matchfile" >> ./.gitignore
    git push --set-upstream $GitLabUrl $gitBranchName




















