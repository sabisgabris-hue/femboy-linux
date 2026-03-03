#!/bin/bash
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

# =====================================================================
# O HACK TERMONUCLEAR: Varredura total!
# Procura e destrói o caminho velho em TODOS os arquivos do live-build
# =====================================================================
sudo find /usr/lib/live/build -type f -exec sed -i 's|${LB_DISTRIBUTION}/updates|${LB_DISTRIBUTION}-security|g' {} +
sudo find /usr/lib/live/build -type f -exec sed -i 's|bookworm/updates|bookworm-security|g' {} +
sudo find /usr/share/debootstrap -type f -exec sed -i 's|bookworm/updates|bookworm-security|g' {} + 2>/dev/null || true

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# 1. Configuração limpa
sudo lb config --mode debian --distribution bookworm --bootstrap debootstrap

# 2. Injetando a vacina direto nos arquivos gerados pelo lb config
sudo sed -i 's/LB_SECURITY="true"/LB_SECURITY="false"/g' config/common
sudo sed -i 's/LB_UPDATES="true"/LB_UPDATES="false"/g' config/common

# 3. Forçando os repositórios corretos manualmente para garantir
mkdir -p config/archives
cat <<EOF | sudo tee config/archives/debian.list.chroot
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
EOF

# 4. Build Real
sudo lb build

# 5. Mover a ISO
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "A ISO não foi gerada."
​<!-- end list -->
