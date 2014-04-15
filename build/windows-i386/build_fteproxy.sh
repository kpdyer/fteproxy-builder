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
export CFLAGS="-mwindows -I$INSTDIR/gmp/include -L$INSTDIR/gmp/bin"
export CXXFLAGS="-mwindows -I$INSTDIR/gmp/include -L$INSTDIR/gmp/bin"
export LDFLAGS="-mwindows"
export PYTHON="wine /home/vagrant/.wine/drive_c/Python27/python.exe"

mkdir -p $WORKING_DIR
mkdir -p $INSTDIR
cd $WORKING_DIR

sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales

# depdendencies
sudo apt-get update

sudo apt-get -y --no-install-recommends install m4
sudo apt-get -y --no-install-recommends install git
sudo apt-get -y --no-install-recommends install zip unzip p7zip-full
sudo apt-get -y --no-install-recommends install g++-mingw-w64 mingw-w64
sudo apt-get -y --no-install-recommends install software-properties-common python-software-properties

sudo add-apt-repository -y ppa:ubuntu-wine/ppa
sudo apt-get update
sudo apt-get -y --no-install-recommends install wine1.6


# install python
wineboot -i
wget https://www.python.org/ftp/python/2.7.5/python-2.7.5.msi
wine msiexec /qn /i python-2.7.5.msi
# http://bugs.python.org/issue16472
sed -i 's/self.dll_libraries = get_msvcr()/pass#self.dll_libraries = get_msvcr()/g' /home/vagrant/.wine/drive_c/Python27/Lib/distutils/cygwinccompiler.py


# install setuptools
wget https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.tar.gz
tar zxvf setuptools-1.4.tar.gz
cd setuptools-*
$PYTHON setup.py install
cd ..


# install py2exe
wget http://softlayer-ams.dl.sourceforge.net/project/py2exe/py2exe/0.6.9/py2exe-0.6.9.win32-py2.7.exe
7z x py2exe-0.6.9.win32-py2.7.exe
cp -a PLATLIB/* /home/vagrant/.wine/drive_c/Python27/Lib/site-packages/
cp -a SCRIPTS/* /home/vagrant/.wine/drive_c/Python27/Lib/site-packages/
$PYTHON /home/vagrant/.wine/drive_c/Python27/Lib/site-packages/py2exe_postinstall.py -install
rm /home/vagrant/.wine/drive_c/Python27/Lib/site-packages/py2exe_postinstall.py
rm -rfv PLATLIB
rm -rfv SCRIPTS


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
ac_cv_func_malloc_0_nonnull=yes sh configure --host=i686-w64-mingw32
$PYTHON setup.py build_ext -c mingw32
$PYTHON setup.py install
cd ..


# install zope.interface
wget https://pypi.python.org/packages/source/z/zope.interface/zope.interface-4.0.5.zip
unzip zope.interface-4.0.5.zip
cd zope.interface-*
$PYTHON setup.py build_ext -c mingw32
$PYTHON setup.py install
cd ..


# install twisted
sudo ln -s /home/vagrant/.wine/drive_c/Python27/include/Python.h /home/vagrant/.wine/drive_c/Python27/include/python.h
wget https://pypi.python.org/packages/source/T/Twisted/Twisted-13.1.0.tar.bz2
tar xvf Twisted-13.1.0.tar.bz2
cd Twisted-*
echo '[build_ext]\ncompiler=mingw32' > setup.cfg
$PYTHON setup.py install
cd ..


# install yaml
wget https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz
tar xvf PyYAML-3.11.tar.gz
cd PyYAML-*
$PYTHON setup.py install_lib
cd ..


# install obfsproxy
wget https://pypi.python.org/packages/source/o/obfsproxy/obfsproxy-0.2.4.tar.gz
tar xvf obfsproxy-0.2.4.tar.gz
cd obfsproxy-*
$PYTHON setup.py install_lib
cd ..


# install pytptlib
wget https://pypi.python.org/packages/source/p/pyptlib/pyptlib-0.0.5.tar.gz
tar xvf pyptlib-0.0.5.tar.gz
cd pyptlib-*
$PYTHON setup.py install_lib
cd ..


# install fte
# wget https://pypi.python.org/packages/source/f/fte/fte-0.0.1.tar.gz
git clone https://github.com/kpdyer/libfte.git
mv libfte fte-unstable
# tar xvf fte-0.0.1.tar.gz
cd fte-*
WINDOWS_BUILD=1 CROSS_COMPILE=1 make libre2.a # hack
ln -s $INSTDIR/gmp thirdparty/gmp
cp -a thirdparty/gmp/bin/libgmp-*.dll .
$PYTHON setup.py build_ext -c mingw32
$PYTHON setup.py install_lib
cd ..


# build fteproxy
cd $WORKING_DIR
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
mkdir -p build/bdist.win32/winexe/bundle-2.7
cp -a /home/vagrant/.wine/drive_c/Python27/python27.dll build/bdist.win32/winexe/bundle-2.7/
mkdir -p dist
cp -a $INSTDIR/gmp/bin/libgmp-*.dll dist/
cp -a $INSTDIR/gmp/bin/libgmp-*.dll .
cp -a /home/vagrant/.wine/drive_c/Python27/python27.dll dist/
make dist-windows-i386
$PYTHON ./bin/fteproxy --mode test
