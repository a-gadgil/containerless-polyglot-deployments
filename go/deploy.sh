#!/usr/bin/env bash
set -e

VERSION=${1:-1.0.0}
TARBALL="go-host-service-${VERSION}-linux-amd64.tar.gz"
INSTALL_DIR="/opt/go-host-service"

echo "Deploying version ${VERSION}..."
sudo mkdir -p "${INSTALL_DIR}/releases/${VERSION}"
sudo tar -xzf "go/dist/${TARBALL}" -C "${INSTALL_DIR}/releases/${VERSION}"

# Atomically update current symlink
sudo ln -sfn "${INSTALL_DIR}/releases/${VERSION}" "${INSTALL_DIR}/current"

# Install and restart systemd service
sudo cp "${INSTALL_DIR}/current/systemd/go-host-service.service" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable go-host-service
sudo systemctl restart go-host-service

echo "Deployment complete! Service status:"
sudo systemctl status go-host-service --no-pager