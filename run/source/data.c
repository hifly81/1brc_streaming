#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include<time.h>

#define CHUNK_SIZE 100000000 // Number of rows per chunk
#define TOTAL_ROWS 1000000000 // Total number of rows
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


    srand(hash(42));
    char entries[NUM_CUSTOMERS][ENTRY_LENGTH];

    for (int i = 0; i < NUM_CUSTOMERS; i++) {
       snprintf(entries[i], ENTRY_LENGTH, "ID%03d", i + 1);
    }

    FILE *file;
    char filename[20];
    int i, j;

    time_t start;
    time(&start);
    printf("\nCSV files generate started at: %s", ctime(&start));

    for (j = 0; j < 10; j++) {
        sprintf(filename, "data_%d.csv", j+1);
        file = fopen(filename, "w");

        if (file == NULL) {
            printf("Error opening file.\n");
            return 1;
        }

        printf("Writing on file %s\n", filename);

        for (i = j * CHUNK_SIZE + 1; i <= (j + 1) * CHUNK_SIZE; i++) {
            const char *customer_id = entries[rand() % NUM_CUSTOMERS];

            char order_id[ORDER_ID_LEN + 1];
            for (int j = 0; j < ORDER_ID_LEN; ++j) {
                order_id[j] = 'A' + rand() % 26;
            }
            order_id[ORDER_ID_LEN] = '\0';

            double price = ((double)rand() / RAND_MAX) * 50000.0;

            fprintf(file, "%s;%s;%.2f\n", customer_id, order_id, price);
        }

        fclose(file);
    }

    time_t end;
    time(&end);
    printf("\nCSV files generate ended at: %s", ctime(&end));

    return 0;
}