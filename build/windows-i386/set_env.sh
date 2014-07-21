export WORKING_DIR=/vagrant/sandbox
export INSTDIR=$WORKING_DIR/opt
export CFLAGS="-mwindows -I$INSTDIR/gmp/include -L$INSTDIR/gmp/bin"
export CXXFLAGS="-mwindows -I$INSTDIR/gmp/include -L$INSTDIR/gmp/bin"
export LDFLAGS="-mwindows"
export PYTHON="wine /home/vagrant/.wine/drive_c/Python27/python.exe"
export PLATFORM="windows"
export ARCH=i386
export VERSION=0.2.16
export FTEPROXY_RELEASE=$VERSION-$PLATFORM-$ARCH

mkdir -p $WORKING_DIR
mkdir -p $INSTDIR
