#!/bin/bash

# Tentar atualizar o APT até 3 vezes caso dê erro de rede (Code 100)
for i in {1..3}; do sudo apt-get update && break || sleep 5; done

# Instalar ignorando erros pequenos de pacotes
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

# Ativar o modo "parar se errar" apenas para o build da ISO
set -e

# Usar uma pasta limpa no /tmp
mkdir -p /tmp/femboy_factory
cd /tmp/femboy_factory

# Limpeza profunda
sudo lb clean --purge || true

# Configuração focada em compatibilidade total
sudo lb config --debian-installer live \
               --archive-areas "main contrib non-free" \
               --non-interactive \
               --bootstrap debootstrap

# O COMANDO REAL (Aqui é onde a mágica acontece)
sudo lb build

# Mover o resultado para o GitHub
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "A ISO ainda não apareceu"
​<!-- end list -->
