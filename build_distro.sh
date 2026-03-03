#!/bin/bash
# 1. Instalação limpa das ferramentas (corrigindo o erro de 'cpio')
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# 2. Configuração básica (sem flags que dão erro)
sudo lb config --mode debian --distribution bookworm --bootstrap debootstrap

# 3. A GRANDE MARRETA: Desativar a segurança automática que causa o 404
sudo sed -i 's/LB_SECURITY="true"/LB_SECURITY="false"/' config/common
sudo sed -i 's/LB_UPDATES="true"/LB_UPDATES="false"/' config/common

# 4. Injetar os repositórios CORRETOS manualmente
mkdir -p config/archives
cat <<EOF | sudo tee config/archives/debian.list.chroot
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
EOF

# 5. Rodar o build de verdade
sudo lb build

# 6. Mover a ISO para onde o GitHub consiga ver
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
