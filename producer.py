import pandas as pd
from confluent_kafka import Producer

# Function to read data from CSV file
def read_csv(file_path):
    return pd.read_csv(file_path)

# Function to send data to Kafka topic
def send_to_kafka(bootstrap_servers, topic, data):
    producer = Producer({'bootstrap.servers': bootstrap_servers})

    for _, row in data.iterrows():
        # Convert each row to a string and send it to the Kafka topic
        producer.produce(topic, key=str(row.name), value=str(row))

    producer.flush()

if __name__ == "__main__":
    csv_file_path = 'measurements.csv'

    kafka_bootstrap_servers = 'kafka1:9092,kafka2:9093,kafka3:9094'
    kafka_topic = 'measurements'

    csv_data = read_csv(csv_file_path)

    send_to_kafka(kafka_bootstrap_servers, kafka_topic, csv_data)

    print(f"Data from CSV file '{csv_file_path}' sent to Kafka topic '{kafka_topic}'")
