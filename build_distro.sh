#!/bin/bash
# Limpeza total e configuração automática
apt-get update
apt-get install -y live-build debootstrap xorriso squashfs-tools
mkdir -p /femboy_work && cd /femboy_work
lb config --debian-installer live --archive-areas "main contrib non-free" --non-interactive
lb build
# Move o resultado para onde o GitHub espera
mkdir -p $GITHUB_WORKSPACE/output
mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO não gerada"

