# 1brc challenge with kafka streaming solutions

Inspired by original 1brc challenge:
https://www.morling.dev/blog/one-billion-row-challenge/

⚠️ This challenge does not aim to be competitive with the original challenge. It is a challenge dedicated to streaming technologies that integrate with Apache Kafka. Results will be evaluated taking in consideration complete different measures.

## Pre requirements

- docker engine and docker compose
- about 30GB free space
- homebrew to install https://jrnd.io


## Rules

- Kafka cluster with only **3 brokers**. Cluster must be local only. Reserve approximately 30GB for data.
- Topic with _32 partitions_, _replication factor 3_ and _LogAppendTime_ named _measurements_ for input
- Topic with _32 partitions_, _replication factor 3_ named _results_ for output
- Kafka cluster must run using the script _bootstrap.sh_ from this repository. bootstrap will also create input and output topics.
- Output topic must contain messages with:
  - **Key**: name of the city, example _Rome_ - format: _String_
  - **Value**: _avg/max/min_ temperature, example _16/38/4_ - format _String_
- Brokers will listen on port 9092, 9093 and 9094. No Authentication, so SSL
- Implement a solution with _kstreams, flink, ksql, spark, NiFi..._ reading input data from _measurements_ topic and sink result to _results_ topics. and **run it!**. This is not limited to JAVA!
- EOS is required (we want a valid aggregation result !)
- Ingest data into a kafka topic:
    - create the csv file with script _create_measurements.sh_ from this repository. Reserve approximately 15GB for it
    - read from the input file AND send continuously data to _measurements_ topic using the script _producer.sh_ from this repository
- Validate results using consumer application and run script _verification.sh_ from this repository. Result being driven by difference between timestamp of the first/last produced message in the input and validation timestamp of the final consumer.

💡 Kafka Cluster runs [cp-kafka](https://hub.docker.com/r/confluentinc/cp-kafka), Official Confluent Docker Image for Kafka (Community Version) version 7.5.3, shipping Apache Kafka version 3.5.x

## How to test the challenge

 - Run script _bootstrap.sh_
 - Deploy your solution and run it.
 - Run script _verification.sh_ in a new terminal
 - Run script _create_measurements.sh_
 - Run script _producer.sh_ in a new terminal
 - wait till _verification.sh_ will provide final results. See in output log "SIMULATION ENDED."
 - Clean up, run script _tear-down.sh_

## How to participate in the challenge

- Fork this repo
- Add your solution to folder _challenge-YOURNAME_, example _challenge-hifly_
- Open a Pull Request detailing your solution with instructions on how to deploy it
