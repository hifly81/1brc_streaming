#!/usr/bin/env bash

set +m

#get number of items to generate
# if [ -z "$1" ]; then
#     echo "Usage: $0 <number of items to generate>"
#     exit 1
# fi

# check if jr command is installed
if ! [ -x "$(command -v jr)" ]; then
    echo "Error: jr is not installed." >&2
    exit 1
fi

# check if kcat command is installed
if ! [ -x "$(command -v kcat)" ]; then
    echo "Error: kcat is not installed." >&2
    exit 1
fi

# check if kafka-topics or kafka-topics.sh command is installed
if ! [ -x "$(command -v kafka-topics)" ] && ! [ -x "$(command -v kafka-topics.sh)" ]; then
    echo "Error: kafka-topics or kafka-topics.sh is not installed." >&2
    exit 1
fi

# check if kafka-run-class or kafka-run-class.sh command is installed
if ! [ -x "$(command -v kafka-run-class)" ] && ! [ -x "$(command -v kafka-run-class.sh)" ]; then
    echo "Error: kafka-run-class or kafka-run-class.sh is not installed." >&2
    exit 1
fi

kafka-topics --delete --topic test --bootstrap-server localhost:9092 &>/dev/null
kafka-topics --create --topic test --bootstrap-server localhost:9092 --partitions 32 --replication-factor 3 &>/dev/null

# generate data
#jr template run -f 1ms -d 300000ms -n 10000 --embedded \
jr template run -n 100 -f 1ms -d 100ms --embedded \
    '{{city}};{{format_float "%.1f" (floating 40 5)}}' \
    --seed 32 |
    kcat -F kcat.properties -K , -P -t test

# get latest offset for each partition and calculate total number of items
total=$(kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --time -1 --topic test | awk -F: '{print $3}' | paste -sd+ - | bc)
echo "Total number of items: $total"
