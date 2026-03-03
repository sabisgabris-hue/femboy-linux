#!/bin/bash
apt-get update
apt-get install -y live-build debootstrap xorriso squashfs-tools

# Criar pasta de trabalho
mkdir -p /femboy_work && cd /femboy_work

# Configurar e RODAR o build de verdade
lb config --debian-installer live --archive-areas "main contrib non-free" --non-interactive
sudo lb build  # Este comando aqui é o que gera a ISO

# Criar a pasta que o GitHub vai ler
mkdir -p $GITHUB_WORKSPACE/output
cp *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "Ainda não gerou a ISO"
​<!-- end list -->
