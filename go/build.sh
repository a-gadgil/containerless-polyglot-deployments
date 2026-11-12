#!/usr/bin/env bash
set -e

VERSION=${1:-1.0.0}
APP_NAME="go-host-service"
DIST_DIR="dist"
STAGING_DIR="${DIST_DIR}/release-root"

echo "Building ${APP_NAME} v${VERSION} for Linux AMD64..."

# 1. Navigate into the go directory, compile, and move binary back
cd go
mkdir -p bin
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o "bin/${APP_NAME}" main.go

# 2. Setup release staging structure
rm -rf "${STAGING_DIR}"
mkdir -p "${STAGING_DIR}/bin"
mkdir -p "${STAGING_DIR}/systemd"

# 3. Copy binary and systemd service file into staging
cp "bin/${APP_NAME}" "${STAGING_DIR}/bin/"
cp "systemd/${APP_NAME}.service" "${STAGING_DIR}/systemd/"

# 4. Package into release tarball
echo "Packaging release archive..."
cd "${STAGING_DIR}"
tar -czf "../${APP_NAME}-${VERSION}-linux-amd64.tar.gz" .
cd ../..

echo "Build & packaging complete!"
