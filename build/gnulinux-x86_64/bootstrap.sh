#!/bin/sh

sudo sed -i 's/ftp\.se\.debian/ftp.us.debian/g' /etc/apt/sources.list

cd /vagrant
curl https://raw.github.com/kpdyer/fteproxy/master/BUILDING.linux > build_fteproxy.sh
chmod 755 build_fteproxy.sh
./build_fteproxy.sh
