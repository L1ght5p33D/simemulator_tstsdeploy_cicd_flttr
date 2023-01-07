
#Configuration for a new Fastlane/Gitlab/Codemagic enabled Flutter project
#After setting the values in this file, you'll well on your way to having a fully enabled Flutter CI/CD pipeline



#This directory can exist already or will be created and will contain your generated Flutter project

projectPath="/users/drix/projects/flutterProjects/fastlane"

#Set your local android sdk path e.g. /Library/Android/sdk

androidSDK="/users/drix/Library/Android/sdk"

#Set the path to your ios "Simulator.app"

simulatorPath="/Applications/Xcode.app/Contents/Developer/Applications"

#If you want to test a non default simulator device type
#https://medium.com/xcblog/simctl-control-ios-simulators-from-command-line-78b9006a20dc

useDefaultSimulator=true
customSimulatorId="FB491DF8-C374-40FD-BF47-BFFA29A85D1E"

#If you want to run the local test/release script or auto screenshots, you need to create or have existing android emulator... you can set the name now and create it later.

avdName="aavd"

#Your xcode application loader path

alPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support"


#Flutter project needs a name that is allowed e.g.  dart_package_name_compliant_project

projectName="one_shot_app_x"


#App description. completely unimportant. shows up in pubspec.yaml

projectDesc="A Fastlane configured Flutter project"


#Final display name of app, this must be unique or the app store will reject it. Dont use TEST, use TEST 232083239.

appName="One shot app X"


#You will need to create or download existing google play services json file. Set the path where you want this file stored here. I put mine with /generated. More detailed instructions in READTHIS
servicesJsonPath="/users/drix/Desktop/<api-apijsonid.json>"

#Create a key.jks signing key for the app. Default to yes.
#If "yes" leave the default key path so the template keyProperties file sets the right path. Otherwise set your own.

#NOTE the key.properties keystore path is not intuitive, it gets set relative to the app directory in a declaration in AndroidManifest.xml,  not relative to the file itself... that is why we default to creating the keystore there so be careful if you try making any changes.
createNewAndroidKeystore="yes"

#recommend keep this default
androidKeyAlias="key"
#recommend keep this default
androidKeyStorePath="key.jks"


#set the "distinguished name" for the keygen tool -dname argument. I don't think they really matter too much. Abbreviations are : CN common name, OU organizational unit, O organization L locality S state C country

keyDname="CN=test.testco.com, OU=testco, O=testorg, L=LosAngeles, S=Ca, C=US"

#The new keystore keystore password and key password. Both of these need to be longer than 6 charachters. You will need to put these on CodeMagic later so keep this file or a backup somewhere

androidKeyStorePass="someKeyStorePass"

androidKeyPass="someKeyPass"

#The password to openssl encrypt the keys for storage on project repo for use by fastlane
androidKeyEncryptPass="encryptPass"


#package names convention is 'reverse domain notation'
#recommended to make these the same for iOS and Android
#NOTE:: In some cases, the internet domain name may not be a valid package name. This can occur if the domain name contains a hyphen or other special character, if the package name begins with a digit or other character that is illegal to use as the beginning of a Java name
#Android package name

androidAppPackageName="x.oneshot.app"

#bundle identifier of app

iosAppIdentifier="x.oneshot.app"

#This MUST be the first two segments of the android and ios App package names. Sets the organization parameter for "flutter create" instead of the default "com.example"

packageOrganization="x.oneshot"

#Recommneed to "yes" ... whether to use match to sync certificate and profile, uses existing certificates (you can only have two total on developer account)
#If you change this, consider taking a look at the "fastlane cert" and "fastlane sigh" commands in flutterFastlaneInit.sh to see if the options fit your needs

useMatch=true

#what kind of cert to make, recommend default to "distribution" so can release to TestFlight/ test on devices. Anything else creates development cert with provision specified in iosProvisionType

iosCertType="distribution"

#default to appstore to enable TestFlight, can also be adhoc, development, or enterprise

iosProvisionType="appstore"

# Only applicable if useMatch is not yes. A name to give this provisioning profile if you create one or download if it already exists.
provisionName="AppStore ProvisionName"

# Only applicable if useMatch is not yes The cert id to reuse
certIdToUse="SOMECERTID"

# Only applicable if useMatch is not yes. Creates adhoc profile.
makeAdHocProfile=false

# Two factor authentication will cause problems, however I've had it enabled the whole time and I was fine by setting an app specific password...
#https://developer.apple.com/support/account/authentication/
#you can also create a "sub" account at  https://appstoreconnect.apple.com/access/users and enable in App Store Connect
#https://mmcc007.github.io/fledge/docs/fastlane/

#apple developer email

appleEmail="<developer@email.com>"

#apple dev account password used for fastlane initialization with apple dev portal api

applePass="<icloud dev password>"

#App specific Password ... create at https://appleid.apple.com/account/manage if you need to bypass 2 factor auth on your main dev account

appSpecificPass="<app specific password>"

#developer portal team id

developerPortalTeamId="<dev portal team id>"

#itunes connect account id

itunesConnectId="<itunes connect id>"

#itunes connect team id bundle :: "bundle exec fastlane spaceship" ... login ... "Tunes.select_team" i got away without this though
#itunesConnectTeamId="99999999"

# FastLane match signing repo, set the name here and it the repo will be generated for you. Defaults to using SSL to avoid auth

flMatchRepoUrl="git@gitlab.com:devuser/fastlaneMatchCerts.git"


#from https://docs.fastlane.tools/actions/match/
#When running match for the first time on a new machine, it will ask you for the passphrase for the Git repository. This is an additional layer of security: each of the files will be encrypted using openssl. Make sure to remember the password, as you'll need it when you run match on a different machine. To set the passphrase to decrypt your profiles using an environment variable (and avoid the prompt) use MATCH_PASSWORD.

#This password is important, you will use it to decrypt your certs from the Match repo 

matchPassword="some pass Pass"

#initial local git branch name to create project on, this will be the branch you push to on GitLab as well. eg. "staging" or "production"

gitBranchName="staging"


# Set this to "yes" if you don't have SSL access to gitlab
#test if you have ssl access with "ssh -T 'git@gitlab.com'" and look for the welcome message

# If you set to yes... init script will pause for you to copy the public key, and paste here https://gitlab.com/profile/keys before you continue

addGitLabSSLKey="no"

# your GitLab repo name. can be same or different than project name but suggest keeping similar

glProjectName="one_shot_app_x"


glNamespace="devuser"

#  SSL enabled GitLab url default
#GitLabUrl="https://gitlab.com/${glUsername}/${glProjectName}.git"
GitLabUrl="git@gitlab.com:${glNamespace}/${glProjectName}.git"



#Just leave this here.
scriptPath=$PWD




