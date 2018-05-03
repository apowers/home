#!/bin/bash

dpkg -s golang-1.10 > /dev/null || exit

export GOROOT=/usr/lib/go-1.10
export GOPATH=$HOME/Projects/golang

export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
