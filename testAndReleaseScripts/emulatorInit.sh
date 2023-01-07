#!/bin/bash


cd ..
configFile=./scriptConfig.sh
source $configFile

# not sure if stdout will always have a recognizable term. could just run this with a sleep
#osascript -e 'tell app "Terminal"
#do script "/users/drix/Desktop/fastlaneFlutterScripts/runAndroid.sh"
#end tell'
#sleep 20

cd $androidSDK/emulator


./emulator -avd $avdName -wipe-data -no-snapshot | tee >(if grep -q "boot completed"; then osascript -e 'tell app "Terminal"
        do script "/users/drix/Desktop/fastlaneFlutterScripts/runAndroid.sh"
end tell';
fi)
