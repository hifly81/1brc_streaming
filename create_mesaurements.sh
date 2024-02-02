#!/bin/bash

echo -e "going to install jr --> https://jrnd.io"
brew install jr

echo -e "generating a csv with 1B rows..."
echo -e "city;temperature" > measurements.csv && jr template run -n 1_000_000_000 --embedded '{{city}};{{format_float "%.1f" (floating 40 5)}}' >> measurements.csv