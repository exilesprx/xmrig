#!/bin/bash

echo "Building..."

DOCKER_BUILDKIT=1 docker build -f .docker/app/Dockerfile -t exilesprx/xmrig:build .