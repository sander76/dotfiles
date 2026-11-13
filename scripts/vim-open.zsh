#!/usr/bin/env zsh

usage() {
    print -u2 "Usage: ${0:t} .|file:line[:column]"
}

if (( $# == 0 )); then
    exec vim
elif (( $# != 1 )); then
    usage
    exit 2
fi

if [[ "$1" == "." ]]; then
    exec vim "."
fi

if [[ "$1" =~ ^(.+):([0-9]+):([0-9]+)$ ]]; then
    exec vim "+call cursor(${match[2]},${match[3]})" "${match[1]}"
elif [[ "$1" =~ ^(.+):([0-9]+)$ ]]; then
    exec vim "+${match[2]}" "${match[1]}"
else
    usage
    exit 2
fi
