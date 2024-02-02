# 1brc challenge with kafka streaming solutions

Inspired by original 1brc challenge:
https://www.morling.dev/blog/one-billion-row-challenge/

⚠️ This challenge does not aim to be competitive with the original challenge. It is a challenge dedicated to streaming technologies that integrate with Apache Kafka. Results will be evaluated taking in consideration complete different measures.

## Pre requirements


## Rules

- Kafka cluster with only **3 brokers**. Cluster must be local only. Reserve approximately 30GB for data.
- Topic with _32 partitions_, _replication factor 3_ and _LogAppendTime_ named _measurements_ for input
- Topic with _32 partitions_, _replication factor 3_ named _results_ for output
- Kafka cluster must run using the script _bootstrap.sh_ from this repository. bootstrap will also create input and output topics.
- Implement a solution with _kstreams, flink, ksql, ..._ reading input data from _measurements_ topic and sink result to _results_ topics. and **run it!**
- EOS is required (we want a valid aggregation result !)
- Ingest data into a kafka topic:
    - create the input file csv file. You can use [jr](https://github.com/ugol/jr) tool to do this very easily. Reserve approximately 15GB for it [1]
    - read from the input file AND send continuously data to _measurements_ topic _([kcat](https://github.com/edenhill/kcat), [jr](https://github.com/ugol/jr) or any other tools)_
- Validate results using consumer application and run script _verification.sh_ from this repository. Result being driven by difference between timestamp of the first/last produced message in the input and validation timestamp of the final consumer.

[1]
```bash
$ echo -e "city;temperature" > measurements.csv && jr template run -n 1_000_000_000 --embedded '{{city}};{{format_float "%.1f" (floating 40 5)}}' >> measurements.csv
```

## How to test the challenge

 - Run script _bootstrap.sh_
 - Deploy your solution
 - Run script _verification.sh_
 - wait till _verification.sh_ will provide final results. See in output log "SIMULATION ENDED."

## How to smash the challenge

- Fork this repo
- Add your solution to folder _challenge_
- Open a Pull Request detailing your solution
