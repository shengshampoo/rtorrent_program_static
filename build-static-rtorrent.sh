
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

# xmlrpc-c
cd $WORKSPACE
git clone https://github.com/mirror/xmlrpc-c.git
cd xmlrpc-c/trunk
CFLAGS="-std=gnu17" CXXFLAGS="-std=gnu17" LDFLAGS="-static -no-pie -s" ./configure --prefix=/usr --enable-libxml2-backend
make
make install

# libtorrent
cd $WORKSPACE
git clone https://github.com/rakshasa/libtorrent.git
cd libtorrent
autoreconf -fi
LDFLAGS="-static -no-pie -s" ./configure --prefix=/usr
make
make install

# ncurses
cd $WORKSPACE
aa=6.6
curl -sL https://invisible-mirror.net/archives/ncurses/ncurses-$aa.tar.gz | tar xv --gzip
cd ncurses-$aa
./configure --prefix=/usr  --without-shared --enable-pc-files --enable-overwrite --with-termlib --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make install
make clean
./configure --prefix=/usr  --without-shared  --enable-pc-files --enable-overwrite --with-termlib --enable-widec --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make install

# brotli
cd $WORKSPACE
git clone https://github.com/google/brotli.git
cd brotli
mkdir build
cd build
cmake -G Ninja -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=MinSizeRel -DBUILD_SHARED_LIBS=OFF ..
ninja
ninja install

# curl
cd $WORKSPACE
git clone https://github.com/curl/curl.git
cd curl
autoreconf -fi
CFLAGS=-static LDFLAGS="-static --static -no-pie -s -lnghttp2 -lidn2 -lpsl -lssh2 -lunistring -lbrotlienc -lbrotlidec -lbrotlicommon " \
./configure --prefix=/usr --with-openssl --disable-shared --with-libidn2 --disable-docs --with-libssh2 --with-libpsl --enable-ares
make
make install

# rtorrent
git clone https://github.com/rakshasa/rtorrent.git
cd rtorrent
autoreconf -fi
CFLAGS=-static LDFLAGS="-static --static -no-pie -s" ./configure --prefix=/usr/local/rtorrentmm --with-xmlrpc-c --enable-ipv6 --with-ncursesw --disable-shared
make
make install

cd /usr/local
tar vcJf ./rtorrentmm.tar.xz rtorrentmm

mv ./rtorentmm.tar.xz /work/artifact/
