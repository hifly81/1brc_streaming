#!/usr/bin/env bash

# download kafka, if not already downloaded
if [ ! -f kafka_2.13-3.6.1.tgz ]; then
    wget https://downloads.apache.org/kafka/3.6.1/kafka_2.13-3.6.1.tgz
    tar -xzf kafka_2.13-3.6.1.tgz
fi

# check if kafka-topics command is installed
if ! [ -x "$(command -v kafka-topics)" ]; then
    echo "Error: kafka-topics is not installed." >&2
    exit 1
fi

# check if kafka-run-class or kafka-run-class.sh command is installed
if ! [ -x "$(command -v kafka-run-class)" ] && ! [ -x "$(command -v kafka-run-class.sh)" ]; then
    echo "Error: kafka-run-class or kafka-run-class.sh is not installed." >&2
    exit 1
fi

kafka-topics --delete --topic test --bootstrap-server localhost:9092 &>/dev/null
kafka-topics --create --topic test --bootstrap-server localhost:9092 --partitions 32 --replication-factor 3 &>/dev/null

# run java program
./java_generator_with_file &>1b_java.log &

# wait until total becomes 1B
ITEMS=1000000000
echo "Expected number of items: $ITEMS"
total=0
while [ $total -lt $ITEMS ]; do
    # get latest offset for each partition and calculate total number of items
    total=$(kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --time -1 --topic test | awk -F: '{print $3}' | paste -sd+ - | bc)
    echo "Total number of items: $total"
    sleep 5
done

pkill -9 java
