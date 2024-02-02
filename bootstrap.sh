#!/usr/bin/env bash

# get args from command line (if any) and put them in a variable
docker_args=("$@")
echo "docker_args: ${docker_args[@]}"

# Start the environment
docker-compose ${docker_args[@]} -f docker-compose.yml -f up -d