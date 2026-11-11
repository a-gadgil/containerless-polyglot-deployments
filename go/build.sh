#!/usr/bin/env bash
set -e

APP_NAME="go-host-service"
BUILD_DIR="dist"
VERSION=${VERSION:-"1.0.0"}

# Move into the go directory where go.mod lives
cd "$(dirname "$0")"

echo "Building native binary for ${APP_NAME}..."
mkdir -p ${BUILD_DIR}

# Compile statically linked binary
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ${BUILD_DIR}/${APP_NAME} ./src/main.go

# Package into a release archive artifact
tar -czf ${BUILD_DIR}/${APP_NAME}-${VERSION}-linux-amd64.tar.gz -C ${BUILD_DIR} ${APP_NAME}

echo "Build complete! Artifact produced: go/${BUILD_DIR}/${APP_NAME}-${VERSION}-linux-amd64.tar.gz"
