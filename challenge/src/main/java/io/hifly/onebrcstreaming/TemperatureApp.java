package io.hifly.onebrcstreaming;

import org.apache.kafka.common.serialization.*;
import org.apache.kafka.streams.*;
import org.apache.kafka.streams.kstream.*;

import java.util.Map;
import java.util.Properties;
import java.util.DoubleSummaryStatistics;

public class TemperatureApp {

    public static void main(String[] args) {
        Properties props = new Properties();
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, "temperature-aggregator");
        props.put(StreamsConfig.STATE_DIR_CONFIG, "/tmp/rocksdb");
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka1:9092,kafka2:9093,kafka3:9094");
        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

        StreamsBuilder builder = new StreamsBuilder();
        KStream<String, String> measurementsStream = builder.stream("measurements");

        KTable<String, DoubleSummaryStatistics> aggregatedTable = measurementsStream
                .mapValues(Double::parseDouble)
                .groupByKey()
                .aggregate(
                        DoubleSummaryStatistics::new,
                        (key, newValue, aggValue) -> {
                            aggValue.accept(newValue);
                            return aggValue;
                        },
                        Materialized.with(Serdes.String(), new DoubleSummaryStatisticsSerde())
                );

        // Calculate  average, min and max
        KTable<String, String> resultTable = aggregatedTable.mapValues(stats ->
                stats.getAverage()+"/"+stats.getMin()+"/"+stats.getMax());

        resultTable.toStream().to("results", Produced.with(Serdes.String(), Serdes.String()));

        KafkaStreams streams = new KafkaStreams(builder.build(), props);
        streams.start();
    }

    static class DoubleSummaryStatisticsSerde implements Serde<DoubleSummaryStatistics> {

        @Override
        public Serializer<DoubleSummaryStatistics> serializer() {
            return new DoubleSummaryStatisticsSerializer();
        }

        @Override
        public Deserializer<DoubleSummaryStatistics> deserializer() {
            return new DoubleSummaryStatisticsDeserializer();
        }

        @Override
        public void configure(Map<String, ?> configs, boolean isKey) {
        }

        @Override
        public void close() {
        }

        public static class DoubleSummaryStatisticsSerializer implements Serializer<DoubleSummaryStatistics> {
            @Override
            public byte[] serialize(String topic, DoubleSummaryStatistics data) {
                return data.toString().getBytes();
            }
        }

        public static class DoubleSummaryStatisticsDeserializer implements Deserializer<DoubleSummaryStatistics> {
            @Override
            public DoubleSummaryStatistics deserialize(String topic, byte[] data) {
                String str = new String(data);
                String[] parts = str.split(",");

                long count = Long.parseLong(parts[0].split("=")[1]);
                double sum = Double.parseDouble(parts[1].split("=")[1]);
                double min = Double.parseDouble(parts[3].split("=")[1]);
                double max = Double.parseDouble(parts[7].split("=")[1]);
                return new DoubleSummaryStatistics(count, min, max, sum);

            }
        }
    }
}