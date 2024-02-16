package io.hifly.onebrcstreaming;

public class Order {
    String customerId;
    String orderId;
    double price;

    public Order(String customerId, String orderId, double price) {
        this.customerId = customerId;
        this.orderId = orderId;
        this.price = price;
    }

    public double getPrice() {
        return price;
    }
}