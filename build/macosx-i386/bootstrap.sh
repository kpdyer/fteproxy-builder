#!/bin/sh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAYQDD0chapoUrTaPR6xbI6gLFU+Y/Lcc7YPWFbwl6khIRTAhoMqS7nRllkTshvhGoND6gFHAdOpUfJ2eKeCIDJK4I4pgmynV6Ne9TTfDiBFxZEQFtnQmp2GTSTREoZ8kTNHc= vagrant@vagrant" >> /Users/vagrant/.ssh/authorized_keys

export PATH="/usr/local/bin:/usr/local/share/python:${PATH}"

# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"

# see: https://github.com/kpdyer/fteproxy/issues/64
sudo sed -i -e 's/march=native/march=core2/g' /usr/local/Library/ENV/4.3/cc

# see: https://github.com/kpdyer/fteproxy/issues/65
brew install wget
wget https://raw.github.com/mxcl/homebrew/master/Library/Formula/python.rb
sudo sed -i -e 's/enable-ipv6/disable-ipv6/g' python.rb
brew install python.rb --build-from-source

brew install boost --build-from-source
brew install gmp
brew install git

sudo easy_install pip
sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install gmpy
sudo pip install obfsproxy
sudo pip install pyptlib
sudo pip install pyinstaller
sudo pip install pycrypto
sudo pip install argparse

## SWIG + PCRE
cd ~
curl http://softlayer-dal.dl.sourceforge.net/project/swig/swig/swig-2.0.8/swig-2.0.8.tar.gz > swig-2.0.8.tar.gz
tar zxvf swig-2.0.8.tar.gz
cd swig-2.0.8
curl http://softlayer-dal.dl.sourceforge.net/project/pcre/pcre/8.32/pcre-8.32.tar.gz > pcre-8.32.tar.gz
tar zxvf pcre-8.32.tar.gz
rm pcre-8.32.tar.gz2.sig
./Tools/pcre-build.sh
./configure --prefix=/Users/vagrant/bundle/usr
make
sudo make install

# M2Crypto
cd ~
curl https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.21.1.tar.gz > M2Crypto-0.21.1.tar.gz
tar zxvf M2Crypto-0.21.1.tar.gz
cd M2Crypto-0.21.1
python setup.py build_ext --swig /Users/vagrant/bundle/usr/bin/swig
mkdir -p ~/usr/lib/python2.7/site-packages/
sudo python setup.py install --root=/Users/vagrant/bundle --prefix=/usr

# see: https://github.com/kpdyer/fteproxy/issues/66
sudo touch /usr/local/lib/python2.7/site-packages/zope/__init__.py

cd ~
#git clone https://git.torproject.org/pluggable-transports/bundle.git
git clone https://github.com/kpdyer/bundle
git clone https://git.torproject.org/pluggable-transports/pyptlib.git
git clone https://git.torproject.org/pluggable-transports/obfsproxy.git
git clone https://git.torproject.org/flashproxy.git
git clone https://github.com/kpdyer/fteproxy.git

# see: https://github.com/kpdyer/fteproxy/issues/67
cd ~/fteproxy
make -j`nproc` fte/cDFA.so
install_name_tool -change /System/Library/Frameworks/Python.framework/Versions/2.7/Python /usr/local/Cellar/python/2.7.6/Frameworks/Python.framework/Python fte/cDFA.so
make

cd ~/bundle
make fetch-macosx-i686
make macosx-i686
