#!/usr/bin/env bash

KAFKA_VERSION=3.6.1
KAFKA_DIR=kafka_2.13-$KAFKA_VERSION

# move to the directory of the script
cd producer || exit

# download kafka if directory does not exist
if [ ! -d $KAFKA_DIR ]; then
    wget https://downloads.apache.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz
    tar -xzf kafka_2.13-$KAFKA_VERSION.tgz
    rm kafka_2.13-$KAFKA_VERSION.tgz
fi

# Split the measurements.csv file in 10 smaller files
rm -rf files
mkdir -p files
mv ../data.csv files
cd files || exit
#split -d -n 1 data.csv splitted
split -l 10000000 -d data.csv splitted
mv data.csv ../..
cd ..

# run java program
./app &>app.log

rm -fr $KAFKA_DIR
rm -rf files
pkill -9 java
