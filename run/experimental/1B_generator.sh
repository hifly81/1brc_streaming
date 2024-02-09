#!/usr/bin/env bash

set +m

RANDOM=32

# get number of items to generate
if [ -z "$1" ]; then
    echo "Usage: $0 <number of items to generate>"
    exit 1
fi

ITEMS=$1

# array of cities
cities=("Atlanta" "Austin" "Baltimore" "Boston" "Charlotte" "Chicago" "Cincinnati" "Cleveland"
    "Columbus" "Dallas" "Denver" "Detroit" "Fort Worth" "Houston" "Indianapolis" "Jacksonville"
    "Kansas City" "Las Vegas" "Los Angeles" "Louisville" "Memphis" "Miami" "Milwaukee"
    "Minneapolis" "Nashville" "New Orleans" "New York" "Oklahoma City" "Orlando" "Philadelphia"
    "Phoenix" "Pittsburgh" "Portland" "Raleigh" "Richmond" "Sacramento" "Salt Lake City"
    "San Antonio" "San Diego" "San Francisco" "San Jose" "Seattle" "St. Louis"
    "Tampa" "Tucson" "Washington")

# get number of items to generate
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

# clean data
function clean_data() {
    rm /tmp/1B_generator_*.csv
}

# function to generate random data and send it to Kafka
function generate_data() {
    touch /tmp/1B_generator_$1.csv
    # send data to Kafka
    echo "Sending data to Kafka from process $1 and reading from /tmp/1B_generator_$1.csv file..."
    tail -f /tmp/1B_generator_$1.csv | kcat -F kcat.properties -K , -P -t test &>1b.log &
    # tail -f "/tmp/1B_generator_$1.csv" | kafka-console-producer --bootstrap-server localhost:9092 --topic test \
    #     --property "parse.key=true" \
    #     --property "batch.size=1000" \
    #     --property "compression.type=none" \
    #     --property "linger.ms=500" \
    #     --property "key.separator=," &>1b.log &

    # generate n messages
    for i in $(seq 1 $2); do
        # get random city from cities array
        local city=${cities[$RANDOM * $1 % ${#cities[@]}]}
        # generate random temperature as a floating point number between -10 and 45
        local temperature=$(awk -v seed="$1" 'BEGIN { srand(seed); printf "%.1f", rand() * 55 - 10 }')
        echo "$city,$temperature" >>/tmp/1B_generator_$1.csv
    done
}

# generate data, loop over 10 times
clean_data
PARELLEL_PROCESSES=50
ITEMS_PER_PROCESS=$((ITEMS / PARELLEL_PROCESSES))
for i in $(seq 1 $PARELLEL_PROCESSES); do
    generate_data "$i" "$ITEMS_PER_PROCESS" &
done

total=0
# wait until total becomes 1B
echo "Expected number of items: $ITEMS"
while [ $total -lt $ITEMS ]; do
    # get latest offset for each partition and calculate total number of items
    total=$(kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --time -1 --topic test | awk -F: '{print $3}' | paste -sd+ - | bc)
    echo "Total number of items: $total"
    sleep 5
done

# kill all processes named kcat
pkill -9 kcat
# pkill -9 java

clean_data
