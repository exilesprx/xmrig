#!/bin/bash

echo "Building source..."
DOCKER_BUILDKIT=1 docker compose -f docker-compose.build.yml build source


echo "Building build..."
DOCKER_BUILDKIT=1 docker compose -f docker-compose.build.yml build build


echo "Building miner..."
DOCKER_BUILDKIT=1 docker compose -f docker-compose.build.yml build miner