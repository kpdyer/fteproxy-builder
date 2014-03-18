#!/bin/sh

# This file is part of fteproxy.
#
# fteproxy is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# fteproxy is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with fteproxy.  If not, see <http://www.gnu.org/licenses/>.

# Tested on Debian 7.1.0, Ubuntu 12.04/12.10/13.04/13.10:

# temporary hack: http://stackoverflow.com/questions/20294408/cython-compilation-errors-mno-fused-madd
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

mkdir sandbox
cd sandbox
git clone https://github.com/kpdyer/fteproxy.git
cd fteproxy
make dist
