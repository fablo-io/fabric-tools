#!/usr/bin/env bash

set -euo

HOME="$(cd "$(dirname "$0")" && pwd)"
TOOLS_IMAGE_BASE_NAME="ghcr.io/fablo-io/fabric-tools:3.0.0"

build_and_push_tools() {
    local platform
    local arch

    platform=$(uname -s | tr '[:upper:]' '[:lower:]')
    case $(uname -m) in
        x86_64)
            arch="amd64"
            ;;
        aarch64|arm64)
            arch="arm64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)"
            exit 1
            ;;
    esac

    if [ "${1:-''}" = "--push" ]; then
        docker build \
            --build-arg FABRIC_VERSION=3.0.0 \
            --build-arg ARCH="$arch" \
            --build-arg PLATFORM="$platform" \
            --tag "$TOOLS_IMAGE_BASE_NAME" \
            --push \
            "$HOME"
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
