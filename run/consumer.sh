#!/bin/bash

if command -v python3 &> /dev/null ; then
    echo "Python 3 is installed."
else
    echo "Python 3 is not installed. Please install Python 3 to run this script."
    exit -1
fi

pip3 install confluent_kafka

python3 consumer.py