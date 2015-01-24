Vagrant.configure(2) do |config|

  #Ubuntu 14.04 server (64 bit) base from Atlas
  config.vm.box = "ubuntu/trusty64"

  #Virtualbox Settings
  config.vm.provider "virtualbox" do |v|
    #Sensible name
    v.name = "OpenSC ePass2003 Test"

    #Enable USB support
    v.customize ['modifyvm', :id, '--usb', 'on']

    #Automatically add ePass2003 USB token into VM
    v.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'ePass2003', '--vendorid', '096e', '--productid', '0807']

    #Show GUI (do not run in headless mode)
    v.gui = true
  end

  #Configure VM environment to perform tests
  config.vm.provision "shell", path: "setup.sh"
end
