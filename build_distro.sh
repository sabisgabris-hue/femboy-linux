#!/bin/bash
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# CONFIGURAÇÃO "BLINDADA"
# Usamos o mirror direto para ele não inventar caminhos errados
sudo lb config \
    --mode debian \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --parent-mirror-binary "http://deb.debian.org/debian/" \
    --parent-mirror-bootstrap "http://deb.debian.org/debian/" \
    --parent-mirror-chroot "http://deb.debian.org/debian/" \
    --bootstrap debootstrap

# AQUI ESTÁ O TRUQUE: 
# Vamos desativar o repositório de segurança na marra antes do build
echo "deb http://deb.debian.org/debian bookworm main" | sudo tee config/archives/debian.list.chroot

# Inicia o build real
sudo lb build

mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
