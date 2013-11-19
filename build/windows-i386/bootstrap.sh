#!/bin/sh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAYQDD0chapoUrTaPR6xbI6gLFU+Y/Lcc7YPWFbwl6khIRTAhoMqS7nRllkTshvhGoND6gFHAdOpUfJ2eKeCIDJK4I4pgmynV6Ne9TTfDiBFxZEQFtnQmp2GTSTREoZ8kTNHc= vagrant@vagrant" >> /home/vagrant/.ssh/authorized_keys


/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P asciidoc
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P bash
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P ca-certificates
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P coreutils
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P curl
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P gcc
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P git
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P gnupg
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P grep
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P make
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P mingw-gcc-core
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P perl
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P tar
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P unzip
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P wget
/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P zip


cp /usr/bin/i686-pc-mingw32-gcc /usr/bin/gcc


cd ~
curl https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz > setuptools-1.1.6.tar.gz
tar zxvf setuptools-1.1.6.tar.gz
cd setuptools-1.1.6
/cygdrive/c/Python27/python setup.py install


cd ~
curl http://softlayer-dal.dl.sourceforge.net/project/swig/swigwin/swigwin-2.0.8/swigwin-2.0.8.zip > swigwin-2.0.8.zip
unzip swigwin-2.0.8.zip


curl http://chandlerproject.org/pub/Projects/MeTooCrypto/M2Crypto-0.21.1.win32-py2.7.msi > M2Crypto-0.21.1.win32-py2.7.msi
msiexec /q /i M2Crypto-0.21.1.win32-py2.7.msi


cd ~
curl http://softlayer-dal.dl.sourceforge.net/project/sevenzip/7-Zip/9.20/7z920.msi > 7z920.msi
msiexec /q /i 7z920.msi


cd ~
curl https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.tar.gz > pycrypto-2.6.tar.gz
tar zxvf pycrypto-2.6.tar.gz
cd pycrypto-2.6
CROSS_COMPILE=i686-pc-mingw32- ./configure shared mingw
sed -i /cygdrive/c/Python27/Lib/distutils/cygwinccompiler.py -e 's/-mno-cygwin//g'
sed -i /usr/i686-pc-mingw32/sys-root/mingw/include/io.h -e 's/off64_t/_off64_t/g'
sed -i /usr/i686-pc-mingw32/sys-root/mingw/include/unistd.h -e 's/off_t/_off_t/g'
/cygdrive/c/Python27/python setup.py build -cmingw32
/cygdrive/c/Python27/python setup.py install


cd ~
curl https://pypi.python.org/packages/2.7/z/zope.interface/zope.interface-4.0.3-py2.7-win32.egg > zope.interface-4.0.3-py2.7-win32.egg
/cygdrive/c/Python27/Scripts/easy_install zope.interface-4.0.3-py2.7-win32.egg


cd ~
curl http://twistedmatrix.com/Releases/Twisted/12.3/Twisted-12.3.0.win32-py2.7.msi > Twisted-12.3.0.win32-py2.7.msi
msiexec /q /i Twisted-12.3.0.win32-py2.7.msi


cd ~
git clone https://git.torproject.org/pluggable-transports/bundle.git
git clone https://git.torproject.org/pluggable-transports/pyptlib.git
git clone https://git.torproject.org/pluggable-transports/obfsproxy.git
git clone https://git.torproject.org/flashproxy.git


cd ~/bundle
echo "ca_directory = /usr/ssl/certs" > ~/.wgetrc
make fetch-windows PYTHON=/cygdrive/c/Python27/python
sed -i Makefile -e 's/ (x86)//g'
make windows PYTHON=/cygdrive/c/Python27/python
