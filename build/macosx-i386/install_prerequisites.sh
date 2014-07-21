# temporary hack: http://stackoverflow.com/questions/20294408/cython-compilation-errors-mno-fused-madd
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

brew install gmp
brew install git
brew install libyaml
brew install upx

sudo pip install --upgrade pip
sudo pip install --upgrade setuptools
sudo pip install --upgrade twisted
sudo pip install --upgrade pycrypto
sudo pip install --upgrade pyyaml 
sudo pip install --upgrade obfsproxy
sudo pip install --upgrade pyptlib
sudo pip install --upgrade pyinstaller
sudo CFLAGS="-Qunused-arguments" CPPFLAGS="-Qunused-arguments" pip install --upgrade fte

sudo touch /Library/Python/2.7/site-packages/zope/__init__.py
