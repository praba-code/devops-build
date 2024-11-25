#!/bin/bash
# Build the Docker image
docker build -t devops-build:latest .
# Tag the image for Docker Hub
docker tag devops-build:latest prabadevops1003/dev:dev

