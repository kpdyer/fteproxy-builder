sudo apt-get update
sudo update-ca-certificates

sudo apt-get -y --no-install-recommends install build-essential
sudo apt-get -y --no-install-recommends install upx
sudo apt-get -y --no-install-recommends install git-core
sudo apt-get -y --no-install-recommends install python-dev
sudo apt-get -y --no-install-recommends install python-pip
sudo apt-get -y --no-install-recommends install libgmp-dev
sudo apt-get -y --no-install-recommends install libyaml-dev
sudo apt-get -y --no-install-recommends install debhelper
sudo DEBIAN_FRONTEND=noninteractive apt-get install -f

sudo pip install --upgrade pip
sudo pip install --upgrade twisted
sudo pip install --upgrade crypto
sudo pip install --upgrade pyptlib
sudo pip install --upgrade obfsproxy
sudo pip install --upgrade pyinstaller
sudo pip install --upgrade fte
