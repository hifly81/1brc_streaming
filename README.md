# 1brc challenge with kafka streaming solutions

Inspired by original 1brc challenge:
https://www.morling.dev/blog/one-billion-row-challenge/

⚠️ This challenge does not aim to be competitive with the original challenge. It is a challenge dedicated to streaming technologies that integrate with Apache Kafka. Results will be evaluated taking in consideration complete different measures.

## Rules

- Provision a kafka cluster with only **1 broker** _(no replication latency)_. Cluster must be local only. Reserve approximately 30GB for data.
- Create a topic with 32 partitions named _measurements_
- Implement a solution with _kstreams, flink, ksql, ..._ reading input data from _measurements_ topic. and **run it!**
- EOS is required (we want a valid aggregation result !)
- Ingest data into a kafka topic:
    - create the input file csv file. You can use [jr](https://github.com/ugol/jr) tool to do this very easily. Reserve approximately 15GB for it [1]
    - read from the input file AND send continuously data to _measurements_ topic _([kcat](https://github.com/edenhill/kcat), [jr](https://github.com/ugol/jr) or any other tools)_
- Validate results **TODO**

[1]
```bash
$ echo -e "city;temperature" > measurements.csv && jr template run -n 1_000_000_000 --embedded '{{city}};{{format_float "%.1f" (floating 40 5)}}' >> measurements.csv
```

## How to smash the challenge

**TODO**

