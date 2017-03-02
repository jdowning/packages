#!/usr/bin/env bash
set -e

VERSION=${1:-1.4.4}
temp_container=$(docker create hitch:${VERSION-latest})
docker cp $temp_container:/tmp/hitch_${VERSION}_all.deb ./hitch_${VERSION}_all.deb
docker rm -v $temp_container
