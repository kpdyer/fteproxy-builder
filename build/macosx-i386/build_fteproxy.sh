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

# temporary hack: http://stackoverflow.com/questions/20294408/cython-compilation-errors-mno-fused-madd
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

brew install --build-from-source python
brew install --build-from-source gmp
brew install --build-from-source git
brew install --build-from-source libyaml
brew install --build-from-source upx

sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install --upgrade twisted
sudo pip install --upgrade pycrypto
sudo pip install --upgrade pyyaml 
sudo pip install --upgrade obfsproxy
sudo pip install --upgrade pyptlib
sudo pip install --upgrade pyinstaller
sudo pip install --upgrade fte

sudo touch /Library/Python/2.7/site-packages/zope/__init__.py

mkdir sandbox
cd sandbox
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
make dist
make test
