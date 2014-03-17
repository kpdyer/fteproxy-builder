INSTALL
=======

This file overviews how one can setup their OSX evironment for running 

* Install VirutalBox: https://www.virtualbox.org/
* Install Vagrant: http://www.vagrantup.com/
* Install the follow three boxes and make them available to vagrant:
    * ```ubuntu-12.10-i386``` - used to cross-compile for windows platform
    * ```debian-7.1.0-i386``` - used to produce 32-bit linux binaries
    * ```debian-7.1.0-amd64``` - used to produce 64-bit linux binaries
* Setup your OSX environment:
```
# install homebrew
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"

# install python, gmp, git, and upx
brew install --build-from-source python
brew install --build-from-source gmp
brew install --build-from-source git
brew install --build-from-source upx

# install our python depdencies
sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install --upgrade twisted
sudo pip install --upgrade pycrypto
sudo pip install --upgrade obfsproxy
sudo pip install --upgrade pyptlib
sudo pip install --upgrade pyinstaller

# see: https://github.com/kpdyer/fteproxy/issues/66
sudo touch /usr/local/lib/python2.7/site-packages/zope/__init__.py
```
