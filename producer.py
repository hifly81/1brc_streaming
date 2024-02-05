import pandas as pd
from confluent_kafka import Producer

def chunk(bootstrap_servers, topic, csv_file_path):
    producer = Producer({'bootstrap.servers': bootstrap_servers, 'compression.type': 'gzip'})
    chunksize = 1000
    counter = 0
    for chunk in pd.read_csv(csv_file_path, chunksize=chunksize):
        for _, row in chunk.iterrows():
            print(f"Chunk {counter} - Row '{row.name}' sent'")
            producer.produce(topic, key=str(row.name), value=str(row))
        counter = counter +1
        producer.flush()

if __name__ == "__main__":
    csv_file_path = 'measurements.csv'

    kafka_bootstrap_servers = 'kafka1:9092,kafka2:9093,kafka3:9094'
    kafka_topic = 'measurements'

    chunk(kafka_bootstrap_servers, kafka_topic, csv_file_path)

    print(f"Data from CSV file '{csv_file_path}' sent to Kafka topic '{kafka_topic}'")
