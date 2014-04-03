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
export CFLAGS="-mwindows"
export LDFLAGS="-mwindows"

mkdir -p $WORKING_DIR
mkdir -p $INSTDIR
cd $WORKING_DIR

sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales

# depdendencies
sudo apt-get update

sudo apt-get -y --no-install-recommends install m4
sudo apt-get -y --no-install-recommends install git
sudo apt-get -y --no-install-recommends install zip
sudo apt-get -y --no-install-recommends install g++-mingw-w64
sudo apt-get -y --no-install-recommends install mingw-w64
sudo apt-get -y --no-install-recommends install unzip

sudo add-apt-repository -y ppa:ubuntu-wine/ppa
sudo apt-get update
sudo apt-get -y --no-install-recommends install wine


# install python
wineboot -i
wget https://www.python.org/ftp/python/2.7.6/python-2.7.6.msi
wine msiexec /qn /i python-2.7.6.msi
export PYTHON="wine /home/vagrant/.wine/drive_c/Python27/python.exe"


# setuptools
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-3.4.1.tar.gz
tar zxvf setuptools-3.4.1.tar.gz
cd setuptools-*
$PYTHON setup.py build_ext -c mingw32
$PYTHON setup.py install_lib
cd ..


# install py2exe
wget http://softlayer-ams.dl.sourceforge.net/project/py2exe/py2exe/0.6.9/py2exe-0.6.9.win32-py2.7.exe
7z x py2exe-0.6.9.win32-py2.7.exe
cp -a PLATLIB/* /home/vagrant/.wine/drive_c/Python27/Lib/site-packages/


# install wrappers, to expose mingw compilers to wine
export WINEROOT=$HOME/.wine/drive_c
cp -rfv ../wine-wrappers .
cd wine-wrappers
mkdir -p build/bdist.win32/winexe/bundle-2.7
cp -a /home/vagrant/.wine/drive_c/Python27/python27.dll build/bdist.win32/winexe/bundle-2.7/
$PYTHON setup.py py2exe
cp -a dist/gcc.exe dist/g++.exe dist/dllwrap.exe dist/swig.exe $WINEROOT/windows/
cd ..


# install gmp
wget https://ftp.gnu.org/gnu/gmp/gmp-5.1.3.tar.bz2
tar xvf gmp-5.1.3.tar.bz2
cd gmp-*
./configure --prefix=$INSTDIR/gmp --build=i686-gnu-linux --host=i686-w64-mingw32 --enable-cxx --disable-static --enable-shared
make
make install
cd ..


# install pycrypto
wget https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz
tar xvf pycrypto-2.6.1.tar.gz
cd pycrypto-*
# This is bogus, that we run the configure script in the build environment, but it seems to work.
# https://bugs.launchpad.net/pycrypto/+bug/1096207 for ac_cv_func_malloc_0_nonnull.
ac_cv_func_malloc_0_nonnull=yes sh configure --host=i686-w64-mingw32 --with-gmp=$INSTDIR/gmp
$PYTHON setup.py build_ext -c mingw32
$PYTHON setup.py install_lib
cd ..


# install zope.interface
wget https://pypi.python.org/packages/source/z/zope.interface/zope.interface-3.6.7.zip
unzip zope.interface-3.6.7.zip
cd zope.interface-*
$PYTHON setup.py build -c mingw32
$PYTHON setup.py install_lib
cd ..


# install twisted
wget https://pypi.python.org/packages/2.7/T/Twisted/Twisted-13.2.0.win32-py2.7.msi
wine msiexec /qn /i Twisted-13.2.0.win32-py2.7.msi


# install obfsproxy
wget https://pypi.python.org/packages/source/o/obfsproxy/obfsproxy-0.2.7.tar.gz
tar xvf obfsproxy-0.2.7.tar.gz
cd obfsproxy-*
$PYTHON setup.py build -c mingw32
$PYTHON setup.py install_lib
cd ..


# install pytptlib
wget https://pypi.python.org/packages/source/p/pyptlib/pyptlib-0.0.5.tar.gz
tar xvf pyptlib-0.0.5.tar.gz
cd pyptlib-*
$PYTHON setup.py build -c mingw32
$PYTHON setup.py install_lib
cd ..


# buildfteproxy
cd $WORKING_DIR
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
ln -s $INSTDIR/gmp thirdparty/gmp
cp -a thirdparty/gmp/bin/*.dll .
cp -a /home/vagrant/.wine/drive_c/Python27/python27.dll .
cp -a /usr/lib/gcc/i686-w64-mingw32/4.6/libstdc++-6.dll .
cp -a /home/vagrant/.wine/drive_c/windows/system32/msvcr90.dll .
mkdir dist
make dist-windows-i386
$PYTHON ./bin/fteproxy --mode test
