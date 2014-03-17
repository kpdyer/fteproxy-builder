INSTALL
=======

This file overviews how one can setup their OSX evironment for running 

* Install VirutalBox: https://www.virtualbox.org/
* Install Vagrant: http://www.vagrantup.com/
* Install the follow three boxes and make them available to vagrant:
    * ```ubuntu-12.04-i386``` - 32-bit Ubuntu 12.04
    * ```debian-7.1.0-i386``` - 32-bit Debian 7.1.0
    * ```debian-7.1.0-amd64``` - 64-bit Debian 7.1.0
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

For building vagrant boxes, the following resources are helpful:

* https://cloud-images.ubuntu.com/vagrant/
* https://github.com/tiwilliam/vagrant-debian
