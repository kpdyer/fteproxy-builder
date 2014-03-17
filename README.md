fteproxy-builder
================

This is a helper-project, which builds fteproxy for all of its target platforms.

fteproxy-builder requires OSX, and has been tested on OSX 10.9.


Overview
--------

This project's purpose is to streamline the process of building fteproxy for 32-bit and 64-bit systems, for Linux, OSX and Windows. Specifically, you can use it as follows:

```
$ git clone https://github.com/kpdyer/fteproxy-builder.git
$ cd fteproxy-builder
$ make all
[wait a bit]
$ ls dist/*
dist/fteproxy-darwin-i386.tar.gz
dist/fteproxy-linux-i386.tar.gz
dist/fteproxy-linux-x86_64.tar.gz
dist/fteproxy-windows-i386.zip
```


Requirements
------------

* Vagrant: http://www.vagrantup.com/
* VirtualBox: https://www.virtualbox.org
* Three vagrants boxes:
    * ```ubuntu-12.10-i386``` - used to cross-compile for windows platform
      https://cloud-images.ubuntu.com/vagrant/precise/20140313/precise-server-cloudimg-i386-vagrant-disk1.box
    * ```debian-7.1.0-i386``` - used to produce 32-bit linux binaries
    * ```debian-7.1.0-amd64``` - used to produce 64-bit linux binaries

The OSX packages are compiled natively.


Author
------

Please contact Kevin P. Dyer (kdyer@cs.pdx.edu) if you have any questions.
