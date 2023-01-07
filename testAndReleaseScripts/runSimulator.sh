#!/bin/bash

cd ..
configFile=./scriptConfig.sh
source $configFile


if [ $useDefaultSimulator = false ]; then
    xcrun simctl boot $customSimulatorId
else

cd $simulatorPath

open ./Simulator.app/

fi
sleep 10

cd $projectPath

cd $projectName

deviceList="$(flutter devices)"

iosSimulatorId=$(echo $deviceList | cut -d "•" -f 2 )
iosSimulatorId="$(echo -e "${iosSimulatorId}" | tr -d '[:space:]')"


flutter drive --target=test_driver/app.dart -d $iosSimulatorId




