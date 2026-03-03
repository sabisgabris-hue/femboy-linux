#!/bin/bash
set -e

# Instalar o básico sem perguntas
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools

# LIMPEZA TOTAL: Remover qualquer rastro anterior
sudo lb clean --purge || true

# Criar uma pasta única para esse build
BUILD_DIR="$HOME/femboy_build_$(date +%s)"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configurar com o básico absoluto para não dar erro
lb config --debian-installer live \
          --archive-areas "main contrib non-free" \
          --non-interactive \
          --build-with-chroot true

# O GRANDE COMANDO (Rodar como root)
sudo lb build

# Se chegar aqui, a ISO existe! Vamos mover para o output
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO não encontrada"

