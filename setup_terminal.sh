#!/bin/sh
# Enable shell script strictness
set -eu
# Enable command tracing
set -x

[ ! -e ~/.bashrc ] && ln -s "$PWD/config/terminal/bashrc" ~/.bashrc