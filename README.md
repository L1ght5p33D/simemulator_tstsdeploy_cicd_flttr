Some commands I collected into almost coherent scripts for flutter app testing and fastlane deployment.

INITIAL SETUP AND DEPENDENCIES OSX

Install Xcode command line tools ::: "xcode-select --install"

 make sure the following packages on installed/on path:

flutter
agvtool

If you don't have "envsubst" ::: "brew install gettext"
"brew link --force gettext"

If you dont have "gsed":::  "brew install gnu-sed"

"brew cask install fastlane" if you don't have it then add /your/home/.fastlane/bin/fastlane to path

I had to do   "gem install unf_ext -v '0.0.7.6'"  before fastlane would run
to test if you need stuff for fastlane to run just do a "flutter create test_fastlane" and cd test_fastlane/ios and do "fastlane init" and see if it complains


For automatic screenshots
"brew update && brew install imagemagick"
"pub global activate screenshots"

make sure Android/sdk/platform-tools contains "adb" and add to path in bash_profile or equivalent::
export PATH="/Path/to/Android/sdk/platform-tools:$PATH"
make sure Android/sdk/emulator containts "emulator" and add to path in bash_profile or equivalent::
export PATH="/Path/to/Android/sdk/emulator:$PATH"

may have to link binaries (adb/emulator/flutter) for screenshots to find :: e.g. "sudo ln -sf ~/Library/Android/sdk/platform-tools/adb /usr/local/bin"


Make sure .sh scripts have executable permissions


STEPS ON CODEMAGIC
sign up/log in with gitlab 
any projects on gitlab will be available to build/test on codemagic



CREATE A NEW FASTLANE ENABLED FLUTTER PROJECT

First backup this script directory somewhere...put the copy you run out of near your flutter project or somewhere accessible because it will create generated files associated with your project you can reference later

Set scriptConfig.sh to the values for your new project, be sure to read the comments and set them appropriately

Run flutterFastlaneInit.sh and add any requested input. e.g. it could ask you to add a ssh key to GitLab at one point or auth questions etc... also

NOTE flutterFastlaneInit  will output "All done!" at one point, this is NOT the end of the script. Just wait until you are prompted for input or your regular prompt returns

if you get ios auth problems its probably from two factor authentication. you can try
making app specific password :: https://appleid.apple.com/account/manage and use when prompted for Apple dev account password. This worked well for me
making another developer "sub" account :: https://appstoreconnect.apple.com/access/users

Your ios app record should now be in AppStoreConnect

You can build tests on CodeMagic at this point by setting CodeMagic triggers and doing a "git push" but you won't be able to complete the publish actions

You still need to create the app on Play Console
To allow codemagic to finish everything through until publish, add enough data to get ready for testing, OR follow the FASTLANE SUPPLY instructions later on, (I decided to just edit the data on the console)
You at least need to add the first APK in App Releases.. which will associate the app listing with the android package name from your flutter project
Do a "flutter build apk --release" and upload the build/app/outputs/apk/release/app-release.apk

The new GitLab repository created by flutterFastlaneInit should show up automatically in codemagic
You can now set a few things (just test for example) and a "git push" will run your tests

In CodeMagic UI

Click the gear to go to settings for the repository you just created

Set build triggers as you wish, e.g. setting a trigger for "*staging" will run the build on "git push" from the project repo on your machine at this point (so easy!)

No enviroment variables are needed, we are uploading the credentials later

Enable caching for default $FCI_BUILD_DIR/build directory for faster builds


In test
Flutter test target :: test
enable flutter test
After the first build the flutter drive target we be an option
Flutter drive target :: drive --target=test_driver/app.dart
enable flutter driver

In build
choose desired channel
build for Android&iOS
mode :: Release
xcode :: latest
build arguments
--release on both ios and Android

In publish
in Android code signing add the Keystore:: key.jks and the properties from key.properties. Copies have been made in the scriptDirectory/generated folder
also, in the project, these have been added to .gitIgnore so will not be added to repo/version control

To sign for ios 

Download your provisioning profile and <certId>.cer and <certId>.pem files that were created. You can clone the fastlane match repository from GitLab, the repository was named with flMatchRepoUrl.. and move these files into MatchCertDir
Open the decryptMatchCert.sh script in an editor, set the values of the certs.cer and cert.pem Ids and profile you just downloaded as well as the path where you put them
Run the script and upload the decoded cert.p12 and decodedProfile.mobileprovision to codemagic



In Google Play
Make a Google Play service account:
Go to All applications > Settings > API access > create service account
or if you already have a key with permissions view it > manage > Actions > create key > choose json
put this file in the directory you specified in scriptConfig as "servicesJsonPath" for fastlane to work correctly
upload this file to code magic Play credentials (.json)
choose track, i was mostly testing beta uploads



In App Store Connect
self explanatory
If you have 2 factor auth you will get errors so make an app specific password here:: https://developer.apple.com/support/account/authentication/


Before publishing will work completely we need to upload the first builds to the consoles

create/add android/ios Icons
useful tools ::: https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html
https://makeappicon.com/

App Store Connect
1) go to Runner.xcodeproj Xcode and set/ensure that

The Display Name :: (set in scriptConfig appName)
Bundle Identifier :: (set in scriptConfig iosAppIdentifier)

Manual Signing::
provisioningProfile/cert from match (it will have match in the name) should be in the dropdown automatically

Now instead of archiving, waiting, etc. (so slow)

2) You can use testAndReleaseScripts/upoadIosBuild.sh if you want... just set the values in exportOptions.plist and releaseConfig and run the script,it will upload a Runner.ipa to the Apple Dev Console. This can be used after running tests locally to release to App Store now

OR just follow the standard flutter release instructions (i.e. upload from Xcode, archive.. validate.. etc. )

Play Store
1)I think the best way is to just create the app and initialize the metadata... (store listing, rating, etc) to the point of beta release readiness

OR
2) FASTLANE SUPPLY (optional) you can now use service account with "fastlane supply" to set android metadata but i decdided it was not worth it (you still have to edit a bunch of fields either way, plus if you run this before completeing the fields on the console it doesn't create the directory structure for you)

go to project/android run "fastlane supply init --json_key ./path/to/PlayStoreJsonKeyID.json --package_name my.packagename.ex"

now go to android/fastlane/metadata
set things...
"fastlane supply --apk build/app/outputs/apk/release/app-release.apk"
#more info https://docs.fastlane.tools/actions/supply/



If everything went well git push should now release to app stores if you set the triggers on codemagic :)

CREATE ANOTHER BRANCH
In local repo :: git checkout -b <feature_branch_name>
git push -u <gitLabRepoUrl> <feature_branch_name>



FASTLANE

GENERATE SCREENSHOTS
Run "screenshots" in project directory before any uploading to generate fastlane compatible screenshot metadata

LOCAL
UPLOAD A BUILD TO APP STORE CONNECT WITHOUT RUNNING TESTS
make sure Xcode project settings are correct (standard flutter release style stuff) e.g. build number, certs, etc.
EITHER
1) set enough app information in AppStoreConnect
OR
2) run "fastlane deliver init"/"fastlane deliver download_metadata"
+change text files in /ios/fastlane/metadata
I figured this isn't much easier than just doing it on the Dev Console so i didn't explore it much

Either
1) set build name/number in pubspec.yaml,
2) set exportOptions.plist ... run uploadIosBuild.sh :)
OR
1) set build name/number in pubspec.yaml
2) Set values in ios/Fastfile
3) run "fastlane build_and_deploy_testflight" in ios

UPLOAD A BUILD TO GOOGLE PLAY
1) set build name/number in pubspec.yaml
2) be sure to set GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE env variable to single quoted googleServiceApiKey.json contents
2) run "fastlane beta" or "fastlane <custom lane>" (lanes in project/android/fastlane/Fastfile)


RUN TESTS LOCALLY AND UPLOAD LOCAL BUILD TO PLAY/APPSTORE
Quit any running emulators/remove plugged in devices
Set build name/number in pubspec.yaml
run "buildAndRelease.sh"

GITLAB RUNNER
Set up a Runner with gitlab...  create a google kubernetes instance from Gitlab
create a vm with enough memory, the threshold overflow errors are very weak, they are delayed for one, vague and hard to find. I finally got it running with highmem-2 (I believe it needs memory for the docker container as well as any downloaded flutter dependencies and also the Gradle VM ...  size set in android/gradle.properties) so 10GB to be safe
Wait for it to initialize and then on the same page enable Helm Tiller then GitlabRunner
Put whatever tags that are in the Fastfile lane "tags" attribute in the tags setting of the runner for it to trigger a pipeline

Install docker if you don't have it
Copy /dockerFastlane/imageConfig/Dockerfile somewhere
Run curl -O "https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.2.1-stable.tar.xz" in that directory do download Flutter linux. Or change the version, but be sure to change it in the Dockerfile too
and run  "docker build -t <your image tag> ./" in that directory to test the build.
You can then find the image name with "docker images" and do "docker run -it <image id>" and run whatever commands you want to test from the gitlab.ci.yml (eg changing flutter channel/version, changing fastlane options etc.)
Register the image with GitLab (instructions under Registry menu) by running ::
"docker login registry.gitlab.com"
"docker build -t registry.gitlab.com/<namespace>/<project_name>/<image_name>:<tag_name> ."
"docker push registry.gitlab.com/<namespace>/<project_name>/<image_name>:<tag_name>"  this takes a while
now you will see the image under Registry in Gitlab menu. It might take a minute after the push is complete

Remove .gitlab-ci.yml from .gitignore
Copy /dockerFastlane/TemplateGitlab-ci.yml to your project directory, rename ".gitlab-ci.yml" and change 1ight5p33d/oneshot_app in the image name to your repository name (or whatever image name you used when you registered the image) and in the build script to your repository name too
Set the GOOGLE_DEVELOPER_SERVICE_ACCOUNT_ACTOR_FASTLANE env variable to single quoted Json key contents, as well as androidEncryptPass to the androidKeyEncryptPass from scriptConfig to decrypt the keystore.
Use git push <branch>:<fastlaneTag> to trigger runner build and deploy for desired fastlane lane tags defined in project/android/fastlane/Fastfile











