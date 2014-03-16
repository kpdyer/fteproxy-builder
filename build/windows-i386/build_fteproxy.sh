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

export PATH"="C:\\windows\\system32;C:\\windows;Z:\\usr\\i686-pc-mingw32\\sys-root\\mingw\\bin

WORKING_DIR=/vagrant
INSTDIR=/vagrant/sandbox

# depdendencies
sudo apt-get update

sudo apt-get -y --no-install-recommends install build-essential
sudo apt-get -y --no-install-recommends install upx
sudo apt-get -y --no-install-recommends install git
sudo apt-get -y --no-install-recommends install python-pip
sudo apt-get -y --no-install-recommends install g++-mingw-w64
sudo apt-get -y --no-install-recommends install mingw-w64
sudo apt-get -y --no-install-recommends install wine

#LD_PRELOAD= wineboot -i
#wget https://www.python.org/ftp/python/2.7.6/python-2.7.6.msi
wget http://downloads.activestate.com/ActivePython/releases/2.7.5.6/ActivePython-2.7.5.6-win32-x86.msi
LD_PRELOAD= msiexec /qn /i ActivePython-2.7.5.6-win32-x86.msi TARGETDIR=$INSTDIR/python
INSTPYTHON="wine $INSTDIR/python/python.exe"

wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
LD_PRELOAD= $INSTPYTHON get-pip.py
INSTPIP="wine pip"

wget https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz
cd pycrypto-*
# This is bogus, that we run the configure script in the build environment, but it seems to work.
# https://bugs.launchpad.net/pycrypto/+bug/1096207 for ac_cv_func_malloc_0_nonnull.
ac_cv_func_malloc_0_nonnull=yes sh configure --host=i686-w64-mingw32
LD_PRELOAD= $INSTPYTHON setup.py build_ext -c mingw32
LD_PRELOAD= $INSTPYTHON setup.py install
cd ..

#$INSTPIP install --upgrade pip
#$INSTPIP install --upgrade setuptools
$INSTPIP install --upgrade twisted
$INSTPIP install --upgrade pycrypto
$INSTPIP install --upgrade py2exe

#easy
$INSTPIP install --upgrade obfsproxy
$INSTPIP install --upgrade pyptlib

# see: https://github.com/kpdyer/fteproxy/issues/66
sudo touch /usr/local/lib/python2.7/dist-packages/zope/__init__.py

# fteproxy
cd $WORKING_DIR
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
LD_PRELOAD= PYTHON=$INSTPYTHON make dist-windows-i386
make test
