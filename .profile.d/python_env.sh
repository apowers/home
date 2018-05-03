#!/bin/bash
# Configure Python 3 development environment
# Currently only for Ubuntu

[[ -x `which python3` && -x `which pip3` ]] || exit

alias python='python3'
alias pip='pip3'
