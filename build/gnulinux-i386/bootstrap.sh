#!/bin/sh

cd /vagrant
curl https://raw.github.com/kpdyer/fteproxy/master/BUILDING.linux > build_fteproxy.sh
chmod 755 build_fteproxy.sh
./build_fteproxy.sh
