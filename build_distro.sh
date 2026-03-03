#!/bin/bash
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory

# LIMPEZA TOTAL antes de começar
sudo lb clean --purge || true

# CONFIGURAÇÃO SIMPLIFICADA (Sem mirrors manuais aqui para evitar duplicidade)
sudo lb config \
    --mode debian \
    --distribution bookworm \
    --archive-areas "main contrib non-free non-free-firmware" \
    --bootstrap debootstrap

# RODAR O BUILD DIRETAMENTE
# O live-build vai tentar configurar os repositórios sozinho
sudo lb build

mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
