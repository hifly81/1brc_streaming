#!/bin/bash

chmod +x ./darwin/consumer_arm

# get the architecture of the system
arch=$(uname -m)

if [[ $(uname) == "Darwin" ]]; then
    if [ "$arch" == "x86_64" ]; then
        ./darwin/consumer_x86_64 $1 $2 $3
    else
        ./darwin/consumer_arm $1 $2 $3
    fi
elif [[ $(uname) == "Linux" ]]; then
    if [ "$arch" == "x86_64" ]; then
        ./linux/consumer_x86_64 $1 $2 $3
    else
        echo "Not supported for Linux != x86_64"
    fi
else
    echo "Unknown operating system"
fi