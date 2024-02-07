#!/bin/bash

chmod +x measurements_x86_64
chmod +x measurements_arm

# get the architecture of the system
arch=$(uname -m)

# if architecture is x86_64 then run measurements_x86_64 else run measurements_arm
if [ "$arch" == "x86_64" ]; then
    ./measurements_x86_64
else
    ./measurements_arm
fi
