#!/usr/bin/env bash

set -euo

FABRIC_HOME="$(cd "$(dirname "$0")" && pwd)"
TOOLS_IMAGE_BASE_NAME="ghcr.io/fablo-io/fabric-tools:3.0.0"

build_and_push_tools() {
    if [ "${1:-''}" = "--push" ]; then
        docker buildx build \
            --build-arg FABRIC_VERSION=3.0.0 \
            --platform linux/amd64,linux/arm64 \
            --tag "$TOOLS_IMAGE_BASE_NAME" \
            --push \
            "$FABRIC_HOME"
    else
        docker build \
            --build-arg FABRIC_VERSION=3.0.0 \
            --build-arg ARCH="$arch" \
            --build-arg PLATFORM="$platform" \
            --tag "$TOOLS_IMAGE_BASE_NAME" \
            "$HOME"
    fi
}


build_and_push_tools "$@"
