#!/usr/bin/env bash

KAFKA_VERSION=3.6.1
KAFKA_DIR=kafka_2.13-$KAFKA_VERSION

# move to the directory of the script
cd source || exit

echo -e "Downloading kafka"
# download kafka if directory does not exist
if [ ! -d $KAFKA_DIR ]; then
    wget https://downloads.apache.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz
    tar -xzf kafka_2.13-$KAFKA_VERSION.tgz
    rm kafka_2.13-$KAFKA_VERSION.tgz
fi

# Split data.csv file in smaller files
echo -e "Split data.csv in smaller files..."
rm -rf files
mkdir -p files
mv ../data.csv files
cd files || exit
split -l 100000000 -d data.csv splitted
mv data.csv ../..
cd ..

# run java program
echo -e "Run producer..."
./producer

rm -fr $KAFKA_DIR
rm -rf files
pkill -9 java