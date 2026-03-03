#!/bin/bash
# Garantir que o ambiente esteja pronto
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# CONFIGURAÇÃO "PURO SANGUE"
# Removi --security e --updates que causaram o erro no seu print
sudo lb config \
    --mode debian \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --bootstrap debootstrap

# O grande build
sudo lb build

# Exportar a ISO
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
