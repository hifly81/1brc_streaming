package main

import (
	"encoding/csv"
	"fmt"
	"math/rand"
	"os"
	"time"
)

// List of 46 cities
var cities = []string{
	"Atlanta", "Austin", "Baltimore", "Boston", "Charlotte", "Chicago", "Cincinnati", "Cleveland",
                  "Columbus", "Dallas", "Denver", "Detroit", "Fort Worth", "Houston", "Indianapolis", "Jacksonville",
                  "Kansas City", "Las Vegas", "Los Angeles", "Louisville", "Memphis", "Miami", "Milwaukee",
                  "Minneapolis", "Nashville", "New Orleans", "New York", "Oklahoma City", "Orlando", "Philadelphia",
                  "Phoenix", "Pittsburgh", "Portland", "Raleigh", "Richmond", "Sacramento", "Salt Lake City",
                  "San Antonio", "San Diego", "San Francisco", "San Jose", "Seattle", "St. Louis",
                  "Tampa", "Tucson", "Washington",
}

const numCities = 46

func randomDouble() float64 {
	return float64(rand.Intn(401)) / 10.0
}

func main() {
	var n int
	fmt.Print("Enter the number of rows: ")
	_, err := fmt.Scan(&n)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	rand.Seed(123)

	file, err := os.Create("measurements.csv")
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	defer file.Close()

	writer := csv.NewWriter(file)
	defer writer.Flush()

	for i := 0; i < n; i++ {
		city := cities[rand.Intn(numCities)]
		randomValue := fmt.Sprintf("%.1f", randomDouble()) 
		writer.Write([]string{city, randomValue})
	}

	fmt.Printf("%d rows written to measurements.csv\n", n)
}
