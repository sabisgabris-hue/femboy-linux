#!/bin/bash
# 1. Preparação do ambiente
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# 2. Configuração básica inicial
# Removi as flags que causavam 'unrecognized option' nos seus prints anteriores
sudo lb config --mode debian --distribution bookworm --bootstrap debootstrap

# 3. A correção baseada no link que você achou:
# Forçamos o live-build a NÃO tentar gerar as URLs de segurança sozinho
sudo sed -i 's/LB_SECURITY="true"/LB_SECURITY="false"/' config/common
sudo sed -i 's/LB_UPDATES="true"/LB_UPDATES="false"/' config/common

# 4. Injetamos manualmente o repositório correto (bookworm-security)
mkdir -p config/archives
cat <<EOF | sudo tee config/archives/debian.list.chroot
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
EOF

# 5. Execução do Build
sudo lb build

# 6. Organização do output para o GitHub Actions
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO não encontrada"

