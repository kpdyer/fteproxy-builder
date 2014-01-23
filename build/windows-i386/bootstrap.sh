#!/bin/sh

WORKING_DIR=/vagrant

export PATH=/cygdrive/c/boost/lib:/cygdrive/c/MinGW/bin:/cygdrive/c/Python27:/cygdrive/c/Python27/Scripts:/usr/bin:$PATH

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAYQDD0chapoUrTaPR6xbI6gLFU+Y/Lcc7YPWFbwl6khIRTAhoMqS7nRllkTshvhGoND6gFHAdOpUfJ2eKeCIDJK4I4pgmynV6Ne9TTfDiBFxZEQFtnQmp2GTSTREoZ8kTNHc= vagrant@vagrant" >> /home/vagrant/.ssh/authorized_keys

cd $WORKING_DIR
rm -rfv fteproxy
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
make dist
