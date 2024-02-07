#include <stdio.h>
#include <stdlib.h>
#include <time.h>

const char* cities[] = {
    "Atlanta", "Austin", "Baltimore", "Boston", "Charlotte", "Chicago", "Cincinnati", "Cleveland",
              "Columbus", "Dallas", "Denver", "Detroit", "Fort Worth", "Houston", "Indianapolis", "Jacksonville",
              "Kansas City", "Las Vegas", "Los Angeles", "Louisville", "Memphis", "Miami", "Milwaukee",
              "Minneapolis", "Nashville", "New Orleans", "New York", "Oklahoma City", "Orlando", "Philadelphia",
              "Phoenix", "Pittsburgh", "Portland", "Raleigh", "Richmond", "Sacramento", "Salt Lake City",
              "San Antonio", "San Diego", "San Francisco", "San Jose", "Seattle", "St. Louis",
              "Tampa", "Tucson", "Washington"
};

#define NUM_CITIES 46

double random_double() {
    return (double)(rand() % 1000) / 10.0;
}

int main() {
    int n;
    printf("Enter the number of rows: ");
    scanf("%d", &n);

    FILE *fp;
    fp = fopen("measurements.csv", "w");

    srand(time(NULL));

    for (int i = 0; i < n; ++i) {
        int city_index = rand() % NUM_CITIES;
        const char* city = cities[city_index];
        double random_value = random_double();

        fprintf(fp, "%s,%.1f\n", city, random_value);
    }

    fclose(fp);
    printf("%d rows written to measurements.csv\n", n);
    return 0;
}