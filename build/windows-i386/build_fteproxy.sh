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

# notes:
#  * build gmp from source (plus all depdendencies)

# disable UAC
# set IP address to 192.168.10.11
# set DNS to 8.8.8.8

# install cygwin: http://cygwin.com/setup-x86.exe
# install python 2.7: http://python.org/ftp/python/2.7.6/python-2.7.6.msi
# install py2exe: http://sourceforge.net/projects/py2exe/files/py2exe/0.6.9/py2exe-0.6.9.win32-py2.7.exe/download
# install openssl: http://slproweb.com/download/Win32OpenSSL-1_0_0k.exe
# install pywin32: http://sourceforge.net/projects/pywin32/files/pywin32/Build%20218/pywin32-218.win32-py2.7.exe/download
# install mingw-get: https://sourceforge.net/projects/mingw/files/Installer
#   * via mingw-get install: gcc, g++, gmp


WORKING_DIR=/vagrant

/cygdrive/c/Users/vagrant/Desktop/setup-x86.exe -q -P autoconf \
                                                   -P automake \
                                                   -P bash \
                                                   -P binutils \
                                                   -P coreutils \
                                                   -P curl \
                                                   -P git \
                                                   -P gzip \
                                                   -P make \
                                                   -P patch \
                                                   -P perl \
                                                   -P tar \
                                                   -P unzip \
                                                   -P zip


echo "export PATH=/cygdrive/c/MinGW/bin:/cygdrive/c/Python27:/cygdrive/c/Python27/Scripts:/usr/bin:$PATH" >> ~/.bashrc
export PATH=/cygdrive/c/MinGW/bin:/cygdrive/c/Python27:/cygdrive/c/Python27/Scripts:/usr/bin:$PATH


# see: https://github.com/kpdyer/fteproxy/issues/71
echo "[build]" > /cygdrive/c/Python27/Lib/distutils/distutils.cfg
echo "compiler=mingw32" >> /cygdrive/c/Python27/Lib/distutils/distutils.cfg


# see: https://github.com/kpdyer/fteproxy/issues/72
sed -i -e 's/ -mno-cygwin//g' /cygdrive/c/Python27/Lib/distutils/cygwinccompiler.py


# see: https://github.com/kpdyer/fteproxy/issues/73
sed -i /cygdrive/c/MinGW/include/io.h -e 's/off64_t/_off64_t/g'
sed -i /cygdrive/c/MinGW/include/unistd.h -e 's/off_t/_off_t/g'


mkdir -p $WORKING_DIR


cd $WORKING_DIR
curl https://pypi.python.org/packages/source/s/setuptools/setuptools-1.1.6.tar.gz > setuptools-1.1.6.tar.gz
tar zxvf setuptools-1.1.6.tar.gz
cd setuptools-1.1.6
python setup.py install


cd $WORKING_DIR
curl https://pypi.python.org/packages/source/p/pip/pip-1.4.1.tar.gz > pip-1.4.1.tar.gz
tar zxvf pip-1.4.1.tar.gz
cd pip-1.4.1
python setup.py install

sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install --upgrade twisted
sudo pip install --upgrade pycrypto
sudo pip install --upgrade obfsproxy
sudo pip install --upgrade pyptlib
sudo pip install --upgrade pyinstaller

# see: https://github.com/kpdyer/fteproxy/issues/66
touch /cygdrive/c/Python27/Lib/site-packages/zope/__init__.py


cd $WORKING_DIR
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
make dist
