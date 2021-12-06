#!/bin/bash -ex

git submodule update --init --depth 1 --recursive

make -C dietlibc -j $(nproc)

export DIET=${PWD}/dietlibc/bin-*/diet


cd openssh-portable

export CC="${DIET} -Os \
	gcc -s -static -pipe -nostdinc \
	-D_GNU_SOURCE -D_BSD_SOURCE \
	-DHAVE_GETLINE -DHAVE_BROKEN_CHACHA20"

#export CFLAGS='-static -Wno-traditional '
#export LDFLAGS='-static '

autoreconf

./configure \
    --without-openssl \
    --without-zlib \
    --without-pam \
    --without-xauth

make sftp-server -j $(nproc)
cp sftp-server ..
