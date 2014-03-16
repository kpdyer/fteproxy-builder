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

WORKING_DIR=/vagrant/sandbox
INSTDIR=/vagrant/sandbox/opt
WINEROOT=$HOME/.wine/drive_c

mkdir -p $WORKING_DIR
mkdir -p $INSTDIR
cd $WORKING_DIR

# depdendencies
sudo apt-get update

sudo apt-get -y --no-install-recommends install build-essential
sudo apt-get -y --no-install-recommends install upx
sudo apt-get -y --no-install-recommends install m4
sudo apt-get -y --no-install-recommends install git
sudo apt-get -y --no-install-recommends install python-pip
sudo apt-get -y --no-install-recommends install g++-mingw-w64
sudo apt-get -y --no-install-recommends install mingw-w64
sudo apt-get -y --no-install-recommends install wine
sudo apt-get -y --no-install-recommends install unzip
sudo apt-get -y --no-install-recommends install faketime
sudo apt-get -y --no-install-recommends install p7zip-full


# install python
#wget http://downloads.activestate.com/ActivePython/releases/2.7.5.6/ActivePython-2.7.5.6-win32-x86.msi
#LD_PRELOAD= wine msiexec /qn /i ActivePython-2.7.5.6-win32-x86.msi TARGETDIR=$INSTDIR/python
wget https://www.python.org/ftp/python/2.7.6/python-2.7.6.msi
LD_PRELOAD= wine msiexec /qn /i python-2.7.6.msi TARGETDIR=$INSTDIR/python
INSTPYTHON="wine $INSTDIR/python/python.exe"
INSTEI="wine easy_install"


# install pip
#wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
#LD_PRELOAD= $INSTPYTHON get-pip.py
#INSTPIP="wine pip"


# install py2exe
wget http://softlayer-ams.dl.sourceforge.net/project/py2exe/py2exe/0.6.9/py2exe-0.6.9.win32-py2.7.exe
7z x py2exe-0.6.9.win32-py2.7.exe
cp -a PLATLIB/* /home/vagrant/.wine/drive_c/Python27/Lib/site-packages/


# install wrappers, to expose mingw compilers to wine
cp wine-wrappers
mkdir -p build/bdist.win32/bundle-2.7/
cp /home/vagrant/.wine/drive_c/windows/system32/python27.dll build/bdist.win32/bundle-2.7/
cp /home/vagrant/.wine/drive_c/windows/system32/python27.dll build/bdist.win32/winexe/bundle-2.7/
$INSTPYTHON setup.py py2exe
cp -a dist/gcc.exe dist/g++.exe dist/dllwrap.exe dist/swig.exe $WINEROOT/windows/


# install gmp
wget https://ftp.gnu.org/gnu/gmp/gmp-5.1.3.tar.bz2
tar xvf gmp-5.1.3.tar.bz2
cd gmp-*
./configure --prefix=$INSTDIR/gmp --host=i686-w64-mingw32 --enable-cxx --disable-static --enable-shared
make
make install
cd ..

#echo $'[build]\ncompiler=mingw32' > ~/.wine/drive_c/Python27/Lib/distutils/distutils.cfg

# install pycrypto
wget https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz
cd pycrypto-*
# This is bogus, that we run the configure script in the build environment, but it seems to work.
# https://bugs.launchpad.net/pycrypto/+bug/1096207 for ac_cv_func_malloc_0_nonnull.
ac_cv_func_malloc_0_nonnull=yes sh configure --host=i686-w64-mingw32
LD_PRELOAD= $INSTPYTHON setup.py build_ext -c mingw32
LD_PRELOAD= $INSTPYTHON setup.py install
cd ..


# install twisted
wget https://pypi.python.org/packages/2.7/T/Twisted/Twisted-13.2.0.win32-py2.7.msi
LD_PRELOAD= wine msiexec /qn /i Twisted-13.2.0.win32-py2.7.msi


# install zope.interface
$INSTEI zope.interface


# install obfsproxy
$INSTEI obfsproxy


# install pytptlib
$INSTEI pyptlib


# see: https://github.com/kpdyer/fteproxy/issues/66
#touch /usr/local/lib/python2.7/dist-packages/zope/__init__.py


# buildfteproxy
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
ln -s /vagrant/gmp thirdparty/gmp
LD_PRELOAD= CFLAGS="-I/vagrant/gmp/include" PYTHON=$INSTPYTHON make dist-windows-i386
make test
