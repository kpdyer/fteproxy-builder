#!/bin/sh

sudo apt-get -y update

sudo apt-get -y install git
sudo apt-get -y install make
sudo apt-get -y install zip
sudo apt-get -y install git
sudo apt-get -y install python-argparse
sudo apt-get -y install python-crypto
sudo apt-get -y install python-m2crypto
sudo apt-get -y install python-setuptools
sudo apt-get -y install python-twisted

sudo apt-get -y install m4
sudo apt-get -y install python-dev
sudo apt-get -y install python-gmpy
sudo apt-get -y install libboost-python-dev
sudo apt-get -y install libboost-system-dev
sudo apt-get -y install libboost-filesystem-dev
sudo apt-get -y install libgmp-dev
sudo apt-get -y install python-pip

sudo pip install obfsproxy
sudo pip install pyptlib
sudo pip install pyinstaller

cd $HOME

#git clone https://git.torproject.org/pluggable-transports/bundle.git
git clone https://github.com/kpdyer/bundle.git
git clone https://git.torproject.org/pluggable-transports/pyptlib.git
git clone https://git.torproject.org/pluggable-transports/obfsproxy.git
git clone https://git.torproject.org/flashproxy.git
git clone https://github.com/redjack/fteproxy.git

cd bundle
make fetch-gnulinux-x86_64
make gnulinux-x86_64
cp *.tar.gz /vagrant/
