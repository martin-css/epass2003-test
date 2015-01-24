#!/bin/bash
set -e
echo TOKEN PREPARATION
echo

#Check token inserted
echo "Scanning for token"
if ! opensc-tool -n > /dev/null
then
  echo PLEASE INSERT A TOKEN TO CONTINUE
  exit 1
fi

#Prepare PKCS15 content
echo Preparing token
pkcs15-init -E
pkcs15-init --create-pkcs15 --profile pkcs15+onepin --use-default-transport-key --pin 1234 --puk "123456" --label "Test PIN"
pkcs15-init --store-private-key ~/test.key --auth-id 1 --pin 1234 --label User -u sign,decrypt
echo "Token successfully prepared with PIN 1234"

