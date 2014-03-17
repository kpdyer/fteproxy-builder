#!/bin/sh

# This file is part of fteproxy.
#
# fteproxy is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# fteproxy is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with fteproxy.  If not, see <http://www.gnu.org/licenses/>.

# Tested on Debian 7.1.0, Ubuntu 12.04/12.10/13.04/13.10:

export WORKING_DIR=/vagrant/sandbox
export INSTDIR=$WORKING_DIR/opt
export LIBRARY_PATH="$INSTDIR/lib"
export LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1
export FAKETIME=$REFERENCE_DATETIME
export TZ=UTC
export LC_ALL=C
umask 0022
export PATH="$PATH:/usr/apple-osx/bin/"
export AR=/usr/apple-osx/bin/i686-apple-darwin11-ar
export CC=/usr/apple-osx/bin/i686-apple-darwin11-gcc
export CXX=/usr/apple-osx/bin/i686-apple-darwin11-g++
export LDSHARED="$CC -pthread -shared"
export CFLAGS="-I/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/include/ -I/usr/lib/gcc/i686-apple-darwin10/4.2.1/include/ -I.  -L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/ -L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/system/ -F/usr/lib/apple/SDKs/MacOSX10.6.sdk/System/Library/Frameworks -mmacosx-version-min=10.5 -L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/i686-apple-darwin10/4.2.1 -I$INSTDIR/gmp/include -L$INSTDIR/gmp/lib"
export CXXFLAGS="-I/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/include/ -I/usr/lib/gcc/i686-apple-darwin10/4.2.1/include/ -I.  -L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/ -L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/system/ -F/usr/lib/apple/SDKs/MacOSX10.6.sdk/System/Library/Frameworks -mmacosx-version-min=10.5 -L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/i686-apple-darwin10/4.2.1 -I$INSTDIR/gmp/include -L$INSTDIR/gmp/lib"
export LDFLAGS="-L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/ -L/usr/lib/apple/SDKs/MacOSX10.6.sdk/usr/lib/system/ -F/usr/lib/apple/SDKs/MacOSX10.6.sdk/System/Library/Frameworks -mmacosx-version-min=10.5"

mkdir -p $WORKING_DIR
mkdir -p $INSTDIR

sudo apt-get install faketime
sudo apt-get install python-dev

cd $WORKING_DIR
wget http://packages.siedler25.org/pool/main/a/apple-uni-sdk-10.6/apple-uni-sdk-10.6_20110407-0.flosoft1_i386.deb
sudo dpkg -i apple-uni-sdk-10.6_20110407-0.flosoft1_i386.deb

cd $WORKING_DIR
wget https://mingw-and-ndk.googlecode.com/files/multiarch-darwin11-cctools127.2-gcc42-5666.3-llvmgcc42-2336.1-Linux-120724.tar.xz
cd /usr
sudo tar -Jxvf $WORKING_DIR/multiarch-darwin*tar.xz

cd $WORKING_DIR
# For OpenSSL
sudo ln -s /usr/apple-osx/bin/apple-osx-gcc /usr/apple-osx/bin/i686-apple-darwin11-cc

# install gmp
wget https://ftp.gnu.org/gnu/gmp/gmp-5.1.3.tar.bz2
tar xvf gmp-5.1.3.tar.bz2
cd gmp-*
./configure --prefix=$INSTDIR/gmp --host=i686-apple-darwin11 --enable-cxx --disable-static --enable-shared
make
make install
cd ..


# install setuptools
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-3.3.tar.gz
tar xvf setuptools-3.3.tar.gz
cd setuptools-*
python setup.py install
cd ..


# install pycrypto
wget https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz
tar xvf pycrypto-2.6.1.tar.gz
cd pycrypto-*
# This is bogus, that we run the configure script in the build environment, but it seems to work.
# https://bugs.launchpad.net/pycrypto/+bug/1096207 for ac_cv_func_malloc_0_nonnull.
#ac_cv_func_malloc_0_nonnull=yes sh configure --host=i686-apple-darwin11
python setup.py install
cd ..


# install twisted
wget https://pypi.python.org/packages/source/T/Twisted/Twisted-13.2.0.tar.bz2
tar xvf Twisted-13.2.0.tar.bz2
cd Twisted-*
python setup.py install
cd ..


# install zope.interface
wget https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.1.0.tar.gz
tar xvf zope.interface-4.1.0.tar.gz
cd zope.interface-*
python setup.py install
cd ..


# install obfsproxy
wget https://pypi.python.org/packages/source/o/obfsproxy/obfsproxy-0.2.7.tar.gz
tar xvf obfsproxy-0.2.7.tar.gz
cd obfsproxy-*
python setup.py install
cd ..


# install pytptlib
wget https://pypi.python.org/packages/source/p/pyptlib/pyptlib-0.0.5.tar.gz
tar xvf pyptlib-0.0.5.tar.gz
cd pyptlib-*
python setup.py install
cd ..


# buildfteproxy
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
make dist-osx-i386
