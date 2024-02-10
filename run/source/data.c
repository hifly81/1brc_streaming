#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define NUM_ROWS 1000000000 // 1 billion rows
#define ORDER_ID_LEN 5
#define MAX_PRICE 50000
#define NUM_CUSTOMERS 999
#define ENTRY_LENGTH 9


uint32_t hash(uint32_t x) {
    x ^= x >> 16;
    x *= 0x85ebca6b;
    x ^= x >> 13;
    x *= 0xc2b2ae35;
    x ^= x >> 16;
    return x;
}

int main() {
    FILE *fp = fopen("data.csv", "w");
    if (!fp) {
        fprintf(stderr, "Failed to open file for writing\n");
        return 1;
    }

    srand(hash(42));
    char entries[NUM_CUSTOMERS][ENTRY_LENGTH];

    for (int i = 0; i < NUM_CUSTOMERS; i++) {
        snprintf(entries[i], ENTRY_LENGTH, "ID%03d", i + 1);
    }

    for (int i = 0; i < NUM_ROWS; ++i) {
        const char *customer_id = entries[rand() % 1000];

        char order_id[ORDER_ID_LEN + 1];
        for (int j = 0; j < ORDER_ID_LEN; ++j) {
            order_id[j] = 'A' + rand() % 26;
        }
        order_id[ORDER_ID_LEN] = '\0';

        double price = ((double)rand() / RAND_MAX) * 50000.0;

        fprintf(fp, "%s;%s;%.2f\n", customer_id, order_id, price);
    }

    fclose(fp);

    printf("CSV file generated successfully.\n");

    return 0;
}