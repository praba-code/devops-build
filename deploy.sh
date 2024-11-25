#!/bin/bash
# Pull the image from Docker Hub
docker pull prabadevops1003/dev:dev
# Run the container
docker run -d -p 80:80 prabadevops1003/dev:dev

