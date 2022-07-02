#!/bin/bash

echo "Building..."

DOCKER_BUILDKIT=1 docker build -f ./Dockerfile -t exilesprx/xmrig:build .