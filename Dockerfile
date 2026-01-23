FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required rtorrent 
RUN apk add --no-cache \
  gcc make linux-headers musl-dev \
  zlib-dev zlib-static python3-dev curl \
  libedit-dev libedit-static libedit openssl-dev openssl-libs-static \
  libxml2-static libxml2-dev git g++ libidn2-static libidn2-dev \
  c-ares-static c-ares-dev nghttp2-static nghttp2-dev libpsl-static \
  libpsl-dev xz-static xz-dev zstd-dev zstd-static \
  libssh2-dev libssh2-static libunistring-static \
  libunistring-dev cmake ninja bash xz libtool autoconf automake

ENV XZ_OPT=-e9
COPY build-static-rtorrent.sh build-static-rtorrent.sh
RUN chmod +x ./build-static-rtorrent.sh
RUN bash ./build-static-rtorrent.sh
