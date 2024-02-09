# 1brc challenge with streaming solutions for Apache Kafka

* This is still a WIP project *

Inspired by original 1brc challenge created by Gunnar Morling:
https://www.morling.dev/blog/one-billion-row-challenge/

⚠️ This challenge does not aim to be competitive with the original challenge. It is a challenge dedicated to streaming technologies that integrate with Apache Kafka. Results will be evaluated taking in consideration complete different measures.

## Pre requirements

- docker engine and docker compose
- about 30GB free space
- challenge will run on these supported architectures only:
  - Linux - x86_64
  - Darwin (Mac) - x86_64 and arm 
  - Windows

## Rules

- Kafka cluster with only **3 brokers**. Cluster must be local only. Reserve approximately 30GB for data.
- Topic with **32 partitions**, **replication factor 3** and **LogAppendTime** named **measurements** for input
- Topic with **32 partitions**, **replication factor 3** named **results** for output
- Kafka cluster must run using the script _run/bootstrap.sh_ from this repository. bootstrap will also create input and output topics.
- Brokers will listen on port 9092, 9093 and 9094. No Authentication, no SSL.
- Implement a solution with _kafka APIs, kafka streams, flink, ksql, spark, NiFi, camel-kafka, spring-kafka..._ reading input data from _measurements_ topic and sink results to _results_ topics. and **run it!**. This is not limited to JAVA!
- Ingest data into a kafka topic:
    - Create csv file with script _run/measurements.sh_ or _run/measurements.exe_ from this repository. Reserve approximately 14GB for it. This will take minutes to end.
    -  Each row is one measurement in the format _<string: station name>;<double: measurement>_, with the measurement value having exactly one fractional digit.
  ```
  Miami;28.1
  Dallas;38.1
  Austin;18.3
  Chicago;10.4
  San Diego;24.3
  Cleveland;26.5
  Tucson;5.8
  ..........
  ```

    - There are **913 different cities** 
    - Temperature value: not null double between -40.0 (inclusive) and 40.0 (inclusive), always with one fractional digit
    - Read from csv file AND send continuously data to _measurements_ topic using the script _producer.sh_ from this repository
- Output topic must contain messages with key/value and no additional headers:
  - **Key**: name of the city, example _Austin_ - format: _String_
  - **Value**: _avg/min/max_ temperature, example _16/4/38_ - format _String_
  - Expected to have **913 different messages**
  - The rounding of output values must be done using the semantics of IEEE 754 rounding-direction "roundTowardPositive"
- Validate running script _run/verification.sh_ from this repository.


💡 Kafka Cluster runs [cp-kafka](https://hub.docker.com/r/confluentinc/cp-kafka), Official Confluent Docker Image for Kafka (Community Version) version 7.5.3, shipping Apache Kafka version 3.5.x

💡 Verify messages published into _measurements_ topic with _run/consumer.sh_ script.



1. Run script _run/measurements.sh_ or _run/measurements.exe_ to create 1B csv file.
2. Run script _run/bootstrap.sh_ to setup a Kafka clusters and required topics. 
3. Deploy your solution and run it, publishing data to _results_ topic. 
4. Run script _run/verification.sh_ in a new terminal 
5. Run script _run/producer.sh_ in a new terminal. Producer will read from input file and publish to _measurements_ topic. 
6. wait till _run/verification.sh_ will provide final results. See in output log _"SIMULATION ENDED."_
7. Clean up, run script _run/tear-down.sh_

## How to participate in the challenge

1. Fork this repo
2. Add your solution to folder _challenge-YOURNAME_, example _challenge-hifly_
3. Open a Pull Request detailing your solution with instructions on how to deploy it

✅ Your solution will be tested using the same _docker-compose_ file. Results will be published on this page.

💻 Solutions will be tested on a (TODO) server

💡 A sample implementation is present in folder _challenge_ with Kafka Streams. Test it with:
```
cd challenge
mvn clean compile && mvn exec:java -Dexec.mainClass="io.hifly.onebrcstreaming.TemperatureApp"
```
