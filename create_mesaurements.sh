#!/bin/bash

echo -e "going to install jr --> https://jrnd.io"
brew install jr

echo -e "generating a measurements.csv with 1B rows in current folder. this operation will take time... [!!! BE AWARE file final size will be > 10GB !!!]"

echo -e "city;temperature" > measurements.csv && jr template run -n 1_000_000_000 --embedded '{{city}};{{format_float "%.1f" (floating 40 5)}}' >> measurements.csv

echo -e "measurements.csv with 1B rows CREATED in current folder."
