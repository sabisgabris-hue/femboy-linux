#!/bin/bash
set -e

# Instalar tudo de uma vez
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpion

# Mudar para uma pasta onde o Root tem poder total
cd /tmp
sudo lb clean --purge || true

# Configuração minimalista
sudo lb config --debian-installer live \
               --archive-areas "main contrib non-free" \
               --non-interactive

# RODAR O BUILD (O coração da Femboy Linux)
sudo lb build

# Mover o resultado de volta para o GitHub ver
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO não encontrada"
​<!-- end list -->
