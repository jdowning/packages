FROM ubuntu:xenial

ENV VERSION=1.4.4

RUN apt -qq update && \
    apt install -y \
      automake \
      libev-dev \
      libssl-dev \
      python-docutils \
      flex \
      bison \
      pkg-config \
      ruby \
      ruby-dev \
      wget
RUN gem install --no-doc fpm

COPY hitch.service /tmp/hitch.service
COPY hitch.conf /tmp/hitch.conf
COPY hitch.pem /tmp/hitch.pem
COPY build.sh /tmp/build.sh

RUN /tmp/build.sh
