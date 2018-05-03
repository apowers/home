#!/bin/bash

apt -qy install python3 python3-dev python3-pip
apt -qy install build-essential libssl-dev libffi-dev

pip3 install pylint
pip3 install autopep8


