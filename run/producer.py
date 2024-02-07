import pandas as pd
import time
import datetime
import concurrent.futures
from confluent_kafka import Producer

def read_csv_chunk(filepath, chunk_size):
    chunks = pd.read_csv(filepath, chunksize=chunk_size)
    for chunk in chunks:
        yield chunk

def process_chunk(chunk, producer, topic):
    send_to_kafka(chunk, producer, topic)

def send_messages(bootstrap_servers, topic, csv_file_path):
    producer = Producer({
        'bootstrap.servers': bootstrap_servers,
        'compression.type': 'gzip'
    })
    chunksize = 100000
    ct = datetime.datetime.now()
    start_time = time.time()
    print(f"File sending start time '{format(ct)}'")
    num_threads = 10
    with concurrent.futures.ThreadPoolExecutor(max_workers=num_threads) as executor:
        futures = []
        for chunk in read_csv_chunk(csv_file_path, chunksize):
            futures.append(executor.submit(process_chunk, chunk, producer, topic))

        # Wait for all threads to complete
        for future in concurrent.futures.as_completed(futures):
            future.result()

    producer.flush()
    print(f"Finished sending file to kafka, processing_time='{(time.time() - start_time)}'")
    ct = datetime.datetime.now()
    print(f"File sending end time {format(ct)}")

def send_to_kafka(chunk, producer, topic):
    for _, row in chunk.iterrows():
        print(f"Row '{row.name}'")
        producer.produce(topic, key=str(row[0]), value=str(row[1]), callback=acked)
        producer.poll(0)
    producer.flush()

def acked(err, msg):
    if err is not None:
        print("Failed to deliver message: %s: %s" % (str(msg), str(err)))
    else:
        pass

if __name__ == "__main__":
    csv_file_path = 'measurements.csv'

    kafka_bootstrap_servers = 'kafka1:9092,kafka2:9093,kafka3:9094'
    kafka_topic = 'measurements'

    send_messages(kafka_bootstrap_servers, kafka_topic, csv_file_path)

    print(f"Data from CSV file '{csv_file_path}' sent to Kafka topic '{kafka_topic}'")
