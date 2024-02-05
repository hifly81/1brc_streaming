#!/bin/bash

if command -v python3 &> /dev/null ; then
    echo "Python 3 is installed."
else
    echo "Python 3 is not installed. Please install Python 3 to run this script."
    exit -1
fi

pip3 install csv
pip3 install random

echo -e "generating a measurements.csv with 1B rows in current folder. this operation will take time... [!!! BE AWARE file final size will be > 10GB !!!]"

python3 measurements.py

echo -e "measurements.csv with 1B rows CREATED in current folder."