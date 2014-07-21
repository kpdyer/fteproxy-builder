PLATFORM_UNAME=`uname`
PLATFORM=`echo $PLATFORM_UNAME | tr A-Z a-z`
ARCH=`arch`
VERSION=0.2.16
FTEPROXY_RELEASE=$VERSION-$PLATFORM-$ARCH
WORKING_DIR=./sandbox

mkdir -p $WORKING_DIR
cd $WORKING_DIR

git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
python setup.py test

pyinstaller --clean fteproxy.spec

mkdir -p dist/fteproxy-$FTEPROXY_RELEASE/fteproxy
cp fteproxy/VERSION dist/fteproxy-$FTEPROXY_RELEASE/fteproxy

mkdir -p dist/fteproxy-$FTEPROXY_RELEASE/fteproxy/defs
cp fteproxy/defs/*.json dist/fteproxy-$FTEPROXY_RELEASE/fteproxy/defs/

cp README.md dist/fteproxy-$FTEPROXY_RELEASE
cp COPYING dist/fteproxy-$FTEPROXY_RELEASE

cp README.md dist/fteproxy-$FTEPROXY_RELEASE
cp COPYING dist/fteproxy-$FTEPROXY_RELEASE

cd dist
mv fteproxy fteproxy-$FTEPROXY_RELEASE/fteproxy.bin
tar cvf fteproxy-$FTEPROXY_RELEASE.tar fteproxy-$FTEPROXY_RELEASE
gzip -9 fteproxy-$FTEPROXY_RELEASE.tar
rm -rf fteproxy-$FTEPROXY_RELEASE
