#!/bin/bash

chmod +x ./darwin/data_x86_64
chmod +x ./darwin/data_arm
chmod +x ./linux/data_x86_64

# get the architecture of the system
arch=$(uname -m)

if [[ $(uname) == "Darwin" ]]; then
    if [ "$arch" == "x86_64" ]; then
        ./darwin/data_x86_64
    else
        ./darwin/data_arm
    fi
elif [[ $(uname) == "Linux" ]]; then
    if [ "$arch" == "x86_64" ]; then
        ./linux/data_x86_64
    else
        echo "Not supported for Linux != x86_64"
    fi
else
    echo "Unknown operating system"
fi