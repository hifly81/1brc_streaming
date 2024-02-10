#!/usr/bin/env bash

# Start the environment
docker-compose up -d

echo -e "Wait 30 seconds to have cluster running..."

sleep 30

echo -e "Create topics [measurements, results]..."
docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:9092 --create --topic data --replication-factor 3 --partitions 32 --config message.timestamp.type=LogAppendTime
docker exec -it kafka1 kafka-topics --bootstrap-server kafka1:9092 --create --topic results --replication-factor 3 --partitions 32 --config message.timestamp.type=LogAppendTime

echo -e "Cluster ready!"