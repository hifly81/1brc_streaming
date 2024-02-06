from confluent_kafka import Consumer, KafkaError

bootstrap_servers = 'kafka1:9092,kafka2:9093,kafka3:9094'

topic = 'measurements'

group_id = 'sample_measurements_consumer_group_id'

conf = {
    'bootstrap.servers': bootstrap_servers,
    'group.id': group_id,
    'auto.offset.reset': 'earliest'
}

consumer = Consumer(conf)

consumer.subscribe([topic])

try:
    while True:
        msg = consumer.poll(timeout=1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                print('%% %s [%d] reached end at offset %d\n' %
                      (msg.topic(), msg.partition(), msg.offset()))
            elif msg.error():
                # Error occurred
                raise KafkaException(msg.error())
        else:
            print(f"Received message: '{format(msg.key().decode('utf-8'))}' - '{format(msg.value().decode('utf-8'))}'")

except KeyboardInterrupt:
    # Handle Ctrl+C gracefully
    pass

finally:
    consumer.close()