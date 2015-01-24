# Feitian ePass2003 Testing

This repository has been designed to reliably reproduce concurrency issues that affect the OpenSC PKCS11 library when
used with a [Feitian ePass2003](http://www.ftsafe.com/product/epass/epass2003) token.

These issues are present in version 0.13.0 of OpenSC which was the latest version available in Ubuntu 14.04 at time of writing.

This repository exists so these concurrency issues can be reliably reproduced so that development can take place to rectify the 
issue. 

## Requirements

You need the following to perform the tests:

- [Vagrant](https://www.vagrantup.com/) working install (with [VirtualBox](https://www.virtualbox.org/) support)
- VirtualBox extension pack installed (for USB support)
- An ePass2003 token
- Git

VirtualBox has been configured to display the GUI for the VM. It has also been configured to add USB support and contains
a filter to automatically pass any plugged in ePass2003 token to the VM.

## Installation

These instructions have been written for Linux but can be adapted for other environments, e.g. Microsoft Windows.

Clone the Git repository to an appropriate location on your computer.

```git clone https://github.com/martin-css/epass2003-test.git```	

Create the virtual machine image with Vagrant.

```cd epass2003-test && vagrant up```

The virtual machine image will be created and provisioned on your computer. The `setup.sh` script is used to automatically
installed OpenSC, create a RSA private key and enable this for SSH authentication.

## Token Preparation

Use Vagrant to SSH to your VM.

```vagrant ssh```

Prepare your token by running the token preparation script.

`/vagrant/token-prepare.sh`

This will use the OpenSC tools to initialise your token with a default PIN of **1234** and store the RSA key generated during 
provisioning on the token so the tests can be performed.

*Please note, you only need to run this ONCE. However, if you destroy and re-create the VM, a new key will be generated and the token
will require re-initialised. *

## Testing

The OpenSC PKCS11 library when used with the [ePass2003 driver](https://github.com/OpenSC/OpenSC/blob/master/src/libopensc/card-epass2003.c) has
concurrency issues that cause any application using the PKCS11 library to fail after another application has accessed it. This occurs with
any applications using the `opensc-pkcs11.so` library.

The test script has been written to demonstrate a simple test case that has been encountered in "real-life" usage of these token. This can be ran
by using Vagrant to SSH to your VM if you are not already connected.

```vagrant ssh```

Ensure that your token has been prepared as above. Run the test script, entering the PIN of **1234** when required.

```/vagrant/test_ssh_agent.sh```

This will run through the test cycle and output one of two results at the end.

### TEST COMPLETED SUCCESSFULLY

No concurrency issues have been encountered, multiple applications using the OpenSC PKCS11 library have not caused failures. If you see this
then the issue is resolved!

### OPENSC PKCS11 LIBRARY FAILURE

The test has confirmed that the concurrency issues are still present and multiple applications using the library are causing failures. 

### Something else

If you do not see either of these results then there has been an unexpected error. Please check your configuration and try again.

## Method

The test script runs SSH agent and uses the PKCS11 support to add the `opensc-pkcs11.so` library. The test script then establishes a SSH 
connection to the localhost using your token to confirm that this is working correctly. This step could be repeated multiple times if required
and will work successfully.

The test script then uses the `pkcs11-tool` to run a test cycle on the `opensc-pkcs11.so`. This causes another application to "login"
to the PKCS11 library whilst another application is already using it. The test cycle should complete normally.

The test script will then attempt to establish a SSH connection using your token again. However, because another application has used
the PKCS11 library, this will cause failure of the PKCS11 library and a SSH connection cannot be established. 

This illustrates the concurrency issue, where the last application to login to the PKCS11 library causes any other applications that
had been logged in to fail in any subsequent attempted use of the PKCS11 library.
