#!/bin/sh

sudo sed -i 's/ftp\.se\.debian/ftp.us.debian/g' /etc/apt/sources.list

cd /vagrant
chmod 755 build_fteproxy.sh
./build_fteproxy.sh
