# 1brc challenge with streaming solutions for Apache Kafka

⚠️ **This is still a WIP project**

Inspired by original 1brc challenge created by Gunnar Morling:
https://www.morling.dev/blog/one-billion-row-challenge/

⚠️ This challenge does not aim to be competitive with the original challenge. It is a challenge dedicated to streaming technologies that integrate with Apache Kafka. Results will be evaluated taking in consideration complete different measures.

## Pre requirements

- docker engine and docker compose
- about XXGB free space
- challenge will run on these supported architectures only:
  - Linux - _x86_64_
  - Darwin (Mac) - _x86_64_ and _arm_ 
  - Windows

## Simulation Environment

- Kafka cluster with only **3 brokers**. Cluster must be local only. Reserve approximately XXGB for data.
- Topic with **32 partitions**, **replication factor 3** and **LogAppendTime** named **data** for input
- Topic with **32 partitions**, **replication factor 3** named **results** for output
- Kafka cluster must run using the script _run/bootstrap.sh_ from this repository. bootstrap will also create input and output topics.
- Brokers will listen on port 9092, 9093 and 9094. No Authentication, no SSL.

## Rules

- Implement a solution with _kafka APIs, kafka streams, flink, ksql, spark, NiFi, camel-kafka, spring-kafka..._ reading input data from _data_ topic and sink results to _results_ topics. and **run it!**. This is not limited to JAVA!
- Ingest data into a kafka topic:
    - Create csv file with script _run/data.sh_ or _run/data.exe_ from this repository. Reserve approximately 28GB for it. This will take minutes to end.
    -  Each row is one data in the format _<string: customer id>;<string: order id>;<double: price in EUR>_, with the price value having exactly 2 fractional digits.
  ```
  ID00672;IQRWGNYMHW;363.81
  ID00116;OEWETBQPGW;9162.02
  ID00002;IOIUDDSXGO;15017.20
  ..........
  ```

    - There are **999 different customers** 
    - Price value: not null double between 0.00 (inclusive) and 50000.00 (inclusive), always with 2 fractional digits
    - Read from csv file AND send continuously data to _data_ topic using the script _producer.sh_ from this repository
- Output topic must contain messages with key/value and no additional headers:
  - **Key**: customer id, example _ID00672_ 
  - **Value**: order counts/order counts_with_price > 40000/min price/max price, example _1212/78/4.22/48812.22_ 
  - Expected to have **999 different messages**
  - The rounding of output values must be done using the semantics of IEEE 754 rounding-direction "roundTowardPositive"
- Validate running script _run/verification.sh_ from this repository.


💡 Kafka Cluster runs [cp-kafka](https://hub.docker.com/r/confluentinc/cp-kafka), Official Confluent Docker Image for Kafka (Community Version) version 7.5.3, shipping Apache Kafka version 3.5.x

💡 Verify messages published into _data_ topic with _run/consumer.sh_ script.

1. Run script _run/data.sh_ or _run/data.exe_ to create 1B csv file.
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
mvn clean compile && mvn exec:java -Dexec.mainClass="io.hifly.onebrcstreaming.SampleApp"
```
