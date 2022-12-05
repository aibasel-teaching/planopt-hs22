#!/bin/bash

set -e

cd $(dirname $(realpath $0))

# We do not use a newer version of SoPlex because it requires the
# boost library to be installed.
if [ ! -f soplex-4.0.2.tgz ]; then
    echo "Please download soplex-4.0.2.tgz from https://soplex.zib.de/download.php?fname=soplex-4.0.2.tgz and save the file to this directory."
    exit 1
fi

tar xvf soplex-4.0.2.tgz
cd soplex-4.0.2
mkdir build
cd build
cmake ..
make
make install
