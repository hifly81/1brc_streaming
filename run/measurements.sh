#!/bin/bash

chmod +x ./darwin/measurements_x86_64
chmod +x ./darwin/measurements_arm

# get the architecture of the system
arch=$(uname -m)

if [[ $(uname) == "Darwin" ]]; then
    # if architecture is x86_64 then run measurements_x86_64 else run measurements_arm
    if [ "$arch" == "x86_64" ]; then
        ./darwin/measurements_x86_64
    else
        ./darwin/measurements_arm
    fi
elif [[ $(uname) == "Linux" ]]; then
    echo "Running on Linux"
# Check if running on Windows (using $OSTYPE)
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo "Running on Windows"
else
    echo "Unknown operating system"
fi



