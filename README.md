fteproxy-builder
================

This is a collection of scripts that build fteproxy for all of its target platforms.

The initial release of fteproxy-builder requires OSX, and has been tested on OSX 10.9.


Overview
--------

This project's purpose is to streamline the process of building fteproxy for 32-bit and 64-bit systems, for Linux, OSX and Windows. Specifically, you can use it as follows:

```
$ git clone https://github.com/kpdyer/fteproxy-builder.git
$ cd fteproxy-builder
$ make all
[wait a bit]
$ ls dist/*
dist/fteproxy-X.Y.Z-darwin-i386.tar.gz
dist/fteproxy-X.Y.Z-linux-i386.tar.gz
dist/fteproxy-X.Y.Z-linux-x86_64.tar.gz
dist/fteproxy-X.Y.Z-src.tar.gz
dist/fteproxy-X.Y.Z-windows-i386.zip
```

If you wish to build a specific version or tag of fteproxy, set ```FTEPROXY_TAG``` and/or ```FTEPROXY_VER``` in the Makefile.

Requirements
------------

For details on how to setup your environment, please see ```INSTALL```. In addition, the following four requirements must be met to do full builds for all target platforms.

* OSX 10.9.x
* Vagrant: http://www.vagrantup.com/
* VirtualBox: https://www.virtualbox.org
* Three vagrants boxes:
    * ```ubuntu-12.04-i386``` - used to cross-compile for windows platform
    * ```debian-7.1.0-i386``` - used to produce 32-bit linux binaries
    * ```debian-7.1.0-amd64``` - used to produce 64-bit linux binaries


Author
------

Please contact Kevin P. Dyer (kdyer@cs.pdx.edu) if you have any questions.
