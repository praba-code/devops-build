#!/bin/bash

# Pull the image from DockerHub
docker pull prabadevops1003/dev:latest

# Stop any running container
docker stop dev-app
docker rm dev-app

# Run the container
docker run -d -p 80:80 --name dev-app prabadevops1003/dev:latest

