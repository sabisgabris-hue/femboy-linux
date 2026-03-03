#!/bin/bash
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# 1. Configuração básica (só o que ele aceita)
sudo lb config --mode debian --distribution bookworm --bootstrap debootstrap

# 2. A SOLUÇÃO DEFINITIVA: Criar o arquivo de repositório manualmente
# Isso substitui a busca automática que está dando erro 404
mkdir -p config/archives
cat <<EOF | sudo tee config/archives/debian.list.chroot
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
EOF

# 3. Desativar as tentativas automáticas de segurança do lb config
sudo sed -i 's/LB_SECURITY="true"/LB_SECURITY="false"/' config/common
sudo sed -i 's/LB_UPDATES="true"/LB_UPDATES="false"/' config/common

# 4. Inicia o build
sudo lb build

mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "Aguardando ISO..."
​<!-- end list -->
