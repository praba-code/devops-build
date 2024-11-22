#!/bin/bash

# Build the Docker image
docker build -t devops-build .

# Tag the image with the version
docker tag devops-build prabadevops1003/dev:latest

