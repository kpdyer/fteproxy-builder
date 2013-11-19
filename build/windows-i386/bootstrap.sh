#!/bin/sh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAYQDD0chapoUrTaPR6xbI6gLFU+Y/Lcc7YPWFbwl6khIRTAhoMqS7nRllkTshvhGoND6gFHAdOpUfJ2eKeCIDJK4I4pgmynV6Ne9TTfDiBFxZEQFtnQmp2GTSTREoZ8kTNHc= vagrant@vagrant" >> /home/vagrant/.ssh/authorized_keys


mkdir -p /vagrant
cd /vagrant
curl https://raw.github.com/kpdyer/fteproxy/master/BULIDING.windows > build_fteproxy.sh
chmod 755 build_fteproxy.sh
./build_fteproxy.sh
