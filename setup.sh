#!/bin/bash
set -e
echo "---------------------------"
echo "SETTING UP VM FOR TESTS"
echo "---------------------------"
echo

if ! dpkg -l opensc 2>&1 > /dev/null
then
  echo "Installing OpenSC"
  apt-get update
  apt-get install -y opensc
fi

if [ ! -f test.key ]; then
  echo "Generating OpenSSL key"
  openssl genrsa -out test.key 2048 2>/dev/null
fi
chmod 600 test.key
chown vagrant:vagrant test.key

if ! grep test_key ~vagrant/.ssh/authorized_keys >/dev/null
then
  echo "Adding test key to SSH public authorized keys file"
  KEY=$(ssh-keygen -y -f test.key 2>&1)
  echo "$KEY test_key" >> ~vagrant/.ssh/authorized_keys 
fi


