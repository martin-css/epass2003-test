#!/bin/bash
set -e

SSH="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o PasswordAuthentication=no"

echo "Running SSH agent"
eval $(ssh-agent)

echo "Adding PKCS11 library to SSH agent."
echo "Enter your PIN (default 1234) when prompted"
ssh-add -s opensc-pkcs11.so

echo "Testing initial SSH connection"
$SSH localhost echo Connection was successful

echo "Running PKCS11 tests"
pkcs11-tool --module opensc-pkcs11.so -l -p 1234 -t

if $SSH localhost echo Connection was successful 
then
  echo -e "\033[0;32mTEST COMPLETED SUCCESSFULLY\033[0m"
else
  echo -e "\033[0;31mOPENSC PKCS11 LIBRARY FAILURE\033[0m"
fi


