package io.hifly.onebrcstreaming;

public class OrderStats {
    int numOrders;
    int numOrdersGreaterThan40k;
    double minPrice;
    double maxPrice;

    public void addOrder(Order order) {
        numOrders++;
        if (order.getPrice() > 40000) {
            numOrdersGreaterThan40k++;
        }
        if (order.getPrice() < minPrice || numOrders == 1) {
            minPrice = order.getPrice();
        }
        if (order.getPrice() > maxPrice || numOrders == 1) {
            maxPrice = order.getPrice();
        }
    }
}