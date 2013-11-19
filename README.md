Pluggable Transport Tor Browser Bundle Builder
==============================================

Overview
--------

The PTTBB-builder is a collection of scripts that streamline the process of building the Pluggable Transport Tor Browser Bundle across multiple platforms.
These scripts require VirtualBox images for Linux/OSX/Windows, which are not included as part of this project for licensing reasons. See "Building Virtual Machines" for information on how to build images for each target platform.

The hardest part of getting started is actually building the images. Once built, producing Pluggable Transport Browser Bundles for Linux/OSX/Windows takes only a few minutes.

For each target platform (gnulinux-i386|gnulinux-amd64|windows-i386|macosx-i386) there exists two files:

* Vagrantfile: Contains platform-specific configuration options.
* boostrap.[sh|bat]: Contains all commands required to install depedencies and build the PTTBB for the specific platform. This file is executed automatically after the image is booted.

The bootstrap scripts are based on the pluggable-transport bundler: https://gitweb.torproject.org/pluggable-transports/bundle.git

Depdendencies
-------------

* Vagrant (1.3.x) - http://www.vagrantup.com/
* VirtualBox (4.2.x) - https://www.virtualbox.org/
* A VirtualBox image for each target (Linux/OSX/Windows) platform.


Building Virutal Machines
-------------------------

### Linux

The easiest way to build debian images is to use the vagrant-debian project. Please see: https://github.com/tiwilliam/vagrant-debian

Building vagrant boxes for 32-bit/64-bit platforms is as simple as ```make 32``` and ```make 64```.


### OSX

The process of building OSX images is only officially supported if the host systems is OSX. What's more, VirtualBox does not officially support OSX as a guest OS. The officially supported configuration is to have an OSX host machine, then use parallels (http://www.parallels.com/) as a guest OS with vagrant. However, this is obviously not suitable for everyone.

If you wish to use VirtualBox or a non-OSX host, have a look at: http://www.skoblenick.com/vagrant/vmware-fusion/creating-an-osx-base-box/

In addition, if in VirtualBox you encounter ```Illegal instruction: 4```, you may need to consider the following solution: https://github.com/mxcl/homebrew/issues/19567#issuecomment-18888359

Alternatively, you can email me (kdyer at cs dot pdx dot edu) for more details.

### Windows

As a first step, create a new VirtualBox image with Windows installed.

* Ensure all Windows Updates are installed
* Manually set the IP address to 192.168.10.11
* Manually set DNS to 8.8.8.8

Then, manually install the following packages manually:
* cygwin: http://www.cygwin.com/setup-x86.exe
* Python 2.7: http://python.org/ftp/python/2.7.5/python-2.7.5.msi
* py2exe: http://softlayer-dal.dl.sourceforge.net/project/py2exe/py2exe/0.6.9/py2exe-0.6.9.win32-py2.7.exe
* openssl: http://slproweb.com/download/Win32OpenSSL-1_0_1e.exe


Building PTTBB Binaries
-----------------------

### Assumptions

The build script assumes there exists four vagrant boxes with the following names.

* Debian 7.1.0 32-bit: ```debian-7.1.0-i386```
* Debian 7.1.0 64-bit: ```debian-7.1.0-amd64```
* OSX 10.8 64-bit: ```macosx-i386```
* Windows 7 Professional 32-bit: ```windows7-professional-i386```

Depedening upon the exact details of your build enviroment, you may need to modify Makefile to accomodate for your specific boxes.

### Generating Binaries

Once you have your boxes setup and added to vagrant, type

```
make all
```

then each machine will be booted (serially) and *.tar.gz, *.zip, and *.exe files will appear in dist.
