#!/usr/bin/env bash
set -e

VERSION=${1:-1.4.4}
SRC_DIR=/tmp/hitch-src
DEST_DIR=/tmp/hitch-pkg
OUTPUT_DIR=/tmp

mkdir -p $SRC_DIR
pushd $SRC_DIR
  wget -q https://github.com/varnish/hitch/archive/hitch-${VERSION}.tar.gz && \
  tar --strip-components=1 -xf hitch-${VERSION}.tar.gz && \
  rm hitch-${VERSION}.tar.gz

  ./bootstrap && \
  ./configure && \
  make && \
  make DESTDIR=$DEST_DIR install
popd

mkdir -p $DEST_DIR/etc/{default,hitch}
cp /tmp/hitch.conf $DEST_DIR/etc/hitch/hitch.conf
cp /tmp/hitch.pem $DEST_DIR/etc/hitch/hitch.pem
echo "# hitch environment variables" > $DEST_DIR/etc/default/hitch

pushd $DEST_DIR
  fpm -t deb \
      -s dir \
      --name "hitch" \
      --version "$VERSION"  \
      --architecture "all" \
      --category "misc" \
      --description "A scalable TLS proxy by Varnish Software" \
      --url="http://hitch-tls.org" \
      --vendor "Varnish Software" \
      --maintainer "Justin Downing <justin@downing.us>" \
      --deb-systemd /tmp/hitch.service \
      --prefix=/ \
      .
  mv hitch*.deb $OUTPUT_DIR
popd
