# 1brc challenge with streaming solutions for Apache Kafka

Inspired by original 1brc challenge:
https://www.morling.dev/blog/one-billion-row-challenge/

⚠️ This challenge does not aim to be competitive with the original challenge. It is a challenge dedicated to streaming technologies that integrate with Apache Kafka. Results will be evaluated taking in consideration complete different measures.

## Pre requirements

- _docker engine_ and _docker compose_
- about 30GB free space
- 🐍 _python 3.x_ - Needed in script _create_measurements.sh_ and _producer.sh_.


## Rules

- Kafka cluster with only **3 brokers**. Cluster must be local only. Reserve approximately 30GB for data.
- Topic with _32 partitions_, _replication factor 3_ and _LogAppendTime_ named _measurements_ for input
- Topic with _32 partitions_, _replication factor 3_ named _results_ for output
- Kafka cluster must run using the script _bootstrap.sh_ from this repository. bootstrap will also create input and output topics.
- Brokers will listen on port 9092, 9093 and 9094. No Authentication, no SSL.
- ✴️ Implement a solution with _kafka APIs, kafka streams, flink, ksql, spark, NiFi, camel-kafka, spring-kafka..._ reading input data from _measurements_ topic and sink results to _results_ topics. and **run it!**. ⚠️ This is not limited to JAVA!
- Ingest data into a kafka topic:
    - Create csv file with script _create_measurements.sh_ from this repository. Reserve approximately 14GB for it. ⚠️ This will take minutes to end.
    -  Each row is one measurement in the format _<string: station name>;<double: measurement>_, with the measurement value having exactly one fractional digit.
  ```
  Austin,25.6
  Jacksonville,29.7
  Cincinnati,8.9
  Richmond,27.1
  Oklahoma City,3.5
  Chicago,1.3
  Portland,8.7
  ..........
  ```
    - There are only **46 different cities** with locale **US**
    - Read from csv file AND send continuously data to _measurements_ topic using the script _producer.sh_ from this repository
- Output topic must contain messages with key/value and no additional headers:
  - **Key**: name of the city, example _Rome_ - format: _String_
  - **Value**: _avg/max/min_ temperature, example _16/38/4_ - format _String_
  - Expected to have only **46 different messages**
- Validate results using consumer application and run script _verification.sh_ from this repository. Result being driven by difference between timestamp of the first/last produced message in the input and validation timestamp of the final consumer.

💡 Kafka Cluster runs [cp-kafka](https://hub.docker.com/r/confluentinc/cp-kafka), Official Confluent Docker Image for Kafka (Community Version) version 7.5.3, shipping Apache Kafka version 3.5.x


## How to test the challenge

 - Run script _create_measurements.sh_ to create 1B csv file
 - Run script _bootstrap.sh_ to setup a Kafka clusters and required topics.
 - Deploy your solution and run it, publishing data to _results_ topic. 
 - Run script _verification.sh_ in a new terminal
 - Run script _producer.sh_ in a new terminal. Producer will read from input file and publish to _measurements_ topic.
 - wait till _verification.sh_ will provide final results. See in output log "SIMULATION ENDED."
 - Clean up, run script _tear-down.sh_

## How to participate in the challenge

- Fork this repo
- Add your solution to folder _challenge-YOURNAME_, example _challenge-hifly_
- Open a Pull Request detailing your solution with instructions on how to deploy it

✅ Your solution will be tested using the same _docker-compose_ file. Results will be published on this page.