#!/bin/bash

echo "Verifying..."
DOCKER_BUILDKIT=1 docker run exilesprx/xmrig:build ldd ./xmrig
