#!/bin/bash

config=./scriptConfig.sh
source $config


#set the cer and pem after they're created

    decryptDirPath=$scriptPath"/MatchDecDir"
    nameOfCer=$scriptPath"/MatchCertDir/<Cert Name>.cer"
    nameOfPem=$scriptPath"/MatchCertDir/<Match pem name>.p12"
    nameOfProfile="AppStore_"$iosAppIdentifier".mobileprovision"

cd $decryptDirPath

openssl aes-256-cbc -k $matchPassword -in $nameOfCer -out "cert.der" -a -d

openssl x509 -inform der -in cert.der -out cert.pem

openssl aes-256-cbc -k $matchPassword -in $nameOfPem -out "key.pem" -a -d

openssl pkcs12 -export -out "cert.p12" -inkey key.pem -in cert.pem -password pass:$matchPassword


openssl aes-256-cbc -k $matchPassword -in $nameOfProfile -out "decodedProfile.mobileprovision" -a -d


