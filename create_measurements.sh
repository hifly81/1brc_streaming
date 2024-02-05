#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

echo -e "going to install jr --> https://jrnd.io"
if [ "$machine" == "Mac" ]; then
    brew install jr
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    sudo snap install jrnd
    sudo snap alias jrnd.jr jr
fi


brew install jr

echo -e "generating a measurements.csv with 1B rows in current folder. this operation will take time... [!!! BE AWARE file final size will be > 10GB !!!]"

echo -e "city;temperature" > measurements.csv && jr template run -n 1_000_000_000 --seed 1 --embedded '{{city}};{{format_float "%.1f" (floating 40 5)}}' >> measurements.csv

echo -e "measurements.csv with 1B rows CREATED in current folder."
