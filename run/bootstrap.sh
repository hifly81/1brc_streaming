#!/usr/bin/env bash

# Start the environment
docker-compose up -d

echo -e "Wait 30 seconds to have cluster running..."

sleep 30

INPUT_TOPIC=data
OUTPUT_TOPIC=results

echo -e "Create topics [$INPUT_TOPIC, $OUTPUT_TOPIC]..."
docker exec -it kafka1 kafka-topics --bootstrap-server localhost:9092 --create --topic $INPUT_TOPIC --replication-factor 3 --partitions 32 --config message.timestamp.type=LogAppendTime
docker exec -it kafka1 kafka-topics --bootstrap-server localhost:9092 --create --topic $OUTPUT_TOPIC --replication-factor 3 --partitions 32 --config message.timestamp.type=LogAppendTime

echo -e "Cluster ready!"
