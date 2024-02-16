package io.hifly.onebrcstreaming;

import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.*;
import org.apache.kafka.streams.kstream.*;
import java.util.Properties;

public class SampleApp {

    public static void main(String[] args) {
        Properties props = new Properties();
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, "order-analyzer");
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(StreamsConfig.STATE_DIR_CONFIG, "/tmp/rocksdb");
        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

        StreamsBuilder builder = new StreamsBuilder();
        KStream<String, String> dataStream = builder.stream("data");

        KTable<String, OrderStats> orderStatsTable = dataStream
                .mapValues(value -> {
                    String[] parts = value.split(",");
                    if (parts.length == 3) {
                        String customerId = parts[0];
                        String orderId = parts[1];
                        double price = Double.parseDouble(parts[2]);
                        return new Order(customerId, orderId, price);
                    }
                    return null;
                })
                .filter((key, order) -> order != null)
                .groupByKey()
                .aggregate(
                        OrderStats::new,
                        (key, order, stats) -> {
                            stats.addOrder(order);
                            return stats;
                        },
                        Materialized.with(Serdes.String(), new OrderStatsSerde())
                );

        orderStatsTable.toStream().to("results", Produced.with(Serdes.String(), new OrderStatsSerde()));

        KafkaStreams streams = new KafkaStreams(builder.build(), props);
        streams.start();
    }


    static class OrderStatsSerde extends Serdes.WrapperSerde<OrderStats> {
        public OrderStatsSerde() {
            super(new OrderStatsSerializer(), new OrderStatsDeserializer());
        }
    }
}