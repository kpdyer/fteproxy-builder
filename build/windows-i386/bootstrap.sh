#!/bin/sh

sudo apt-get -y install virtualbox-ose-guest-utils

cd /vagrant
chmod 755 build_fteproxy.sh
./build_fteproxy.sh
