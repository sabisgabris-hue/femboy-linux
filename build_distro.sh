#!/bin/bash
# Retry no update caso a rede oscile
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# CONFIGURAÇÃO "OFFLINE-FIRST"
# Desativamos segurança e atualizações para evitar o erro 404
sudo lb config \
    --mode debian \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --security false \
    --updates false \
    --bootstrap debootstrap

# Inicia o build
sudo lb build

# Exporta o resultado
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
