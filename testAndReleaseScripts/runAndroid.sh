#!/bin/bash

cd ..
configFile=./scriptConfig.sh
source $configFile

cd $projectPath
cd $projectName

deviceList="$(flutter devices)"

androidEmulatorId=$(echo $deviceList | cut -d"•" -f6 )

flutter drive --target=test_driver/app.dart -d $androidEmulatorId 

