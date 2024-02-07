import csv
import random

random.seed(42)

cities = ["Atlanta", "Austin", "Baltimore", "Boston", "Charlotte", "Chicago", "Cincinnati", "Cleveland",
          "Columbus", "Dallas", "Denver", "Detroit", "Fort Worth", "Houston", "Indianapolis", "Jacksonville",
          "Kansas City", "Las Vegas", "Los Angeles", "Louisville", "Memphis", "Miami", "Milwaukee",
          "Minneapolis", "Nashville", "New Orleans", "New York", "Oklahoma City", "Orlando", "Philadelphia",
          "Phoenix", "Pittsburgh", "Portland", "Raleigh", "Richmond", "Sacramento", "Salt Lake City",
          "San Antonio", "San Diego", "San Francisco", "San Jose", "Seattle", "St. Louis",
          "Tampa", "Tucson", "Washington"]

with open('measurements.csv', 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)

    for x in range(0, 1_000_000_000):
        temperature = random.uniform(0, 40)
        csvwriter.writerow([random.choice(cities), round(temperature, 1)])

print("CSV file created successfully: measurements.csv")