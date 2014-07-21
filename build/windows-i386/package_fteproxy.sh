# build fteproxy
cd $WORKING_DIR
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
mkdir -p build/bdist.win32/winexe/bundle-2.7
cp -a /home/vagrant/.wine/drive_c/Python27/python27.dll build/bdist.win32/winexe/bundle-2.7/
mkdir -p dist
cp -a $INSTDIR/gmp/bin/libgmp-10.dll dist/
cp -a /home/vagrant/.wine/drive_c/Python27/python27.dll dist/
cp -a $INSTDIR/gmp/bin/libgmp-10.dll .
$PYTHON ./bin/fteproxy --mode test

# package
$PYTHON setup.py py2exe

cd dist
mkdir -p fteproxy-$FTEPROXY_RELEASE
mv *.dll fteproxy-$FTEPROXY_RELEASE/
mv *.zip fteproxy-$FTEPROXY_RELEASE/
mv *.exe fteproxy-$FTEPROXY_RELEASE/
cd ..

cp README.md dist/fteproxy-$FTEPROXY_RELEASE
cp COPYING dist/fteproxy-$FTEPROXY_RELEASE

mkdir -p dist/fteproxy-$FTEPROXY_RELEASE/fteproxy
cp fteproxy/VERSION dist/fteproxy-$FTEPROXY_RELEASE/fteproxy
cp -rfv fteproxy/defs dist/fteproxy-$FTEPROXY_RELEASE/fteproxy
cp -rfv fteproxy/tests dist/fteproxy-$FTEPROXY_RELEASE/fteproxy

cd dist
zip -9 -r fteproxy-$FTEPROXY_RELEASE.zip fteproxy-$FTEPROXY_RELEASE
rm -rf fteproxy-$FTEPROXY_RELEASE
cd ..
