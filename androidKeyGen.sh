#!/bin/bash

configFile=$scriptPath/scriptConfig.sh
source $configFile

keytool -genkey -noprompt \
 -keyalg RSA \
 -keysize 2048 \
 -validity 10000 \
 -dname "${keyDname}" \
 -alias $androidKeyAlias \
 -keystore  $androidKeyStorePath \
 -storepass $androidKeyStorePass \
 -keypass $androidKeyPass





