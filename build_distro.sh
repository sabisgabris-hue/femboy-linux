#!/bin/bash
# Retry no update caso a rede oscile
for i in {1..3}; do sudo apt-get update && break || sleep 5; done

# Instalação correta (sem o 'n' no cpio)
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# REMOVIDO O --non-interactive QUE DEU ERRO
sudo lb config --debian-installer live \
               --archive-areas "main contrib non-free" \
               --bootstrap debootstrap

# Inicia o build
sudo lb build

# Move o que foi gerado
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
