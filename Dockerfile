# store_management
#

FROM ruby:2.3.3

MAINTAINER Marco Imperia version: 0.1

RUN mkdir -p /root/store
WORKDIR /root/store
ADD . /root/store

