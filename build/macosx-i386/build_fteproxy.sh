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

# Tested on OSX 10.8 with VirtualBox
# !!! Do not run this script in your primary development enviroment.

# update system software
# sudo softwareupdate --install --all

# install xcode
# install xcode command line tools
# enable password-less sudo
# enable ssh access

WORKING_DIR=/vagrant
mkdir -p $WORKING_DIR

export PATH="/usr/local/bin:/usr/local/share/python:${PATH}"

# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"

# see: https://github.com/kpdyer/fteproxy/issues/64
sudo sed -i -e 's/march=native/march=core2/g' /usr/local/Library/Homebrew/extend/ENV/super.rb

brew install --build-from-source python
brew install --build-from-source gmp
brew install --build-from-source git
brew install --build-from-source upx

sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install --upgrade twisted
sudo pip install --upgrade pycrypto
sudo pip install --upgrade obfsproxy
sudo pip install --upgrade pyptlib
sudo pip install --upgrade pyinstaller

# see: https://github.com/kpdyer/fteproxy/issues/66
sudo touch /usr/local/lib/python2.7/site-packages/zope/__init__.py

cd $WORKING_DIR
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy

# see: https://github.com/kpdyer/fteproxy/issues/67
make fte/cDFA
install_name_tool -change /System/Library/Frameworks/Python.framework/Versions/2.7/Python /usr/local/Cellar/python/2.7.6/Frameworks/Python.framework/Python fte/cDFA.so
make dist
