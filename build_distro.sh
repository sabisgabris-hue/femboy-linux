#!/bin/bash
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

# =====================================================================
# O HACK DEFINITIVO: Corrigindo o bug direto no código-fonte da ferramenta
# Substitui o formato antigo de segurança pelo novo formato do Debian Bookworm
# =====================================================================
sudo sed -i 's|${LB_DISTRIBUTION}/updates|${LB_DISTRIBUTION}-security|g' /usr/lib/live/build/chroot_archives

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# 1. Configuração limpa
sudo lb config --mode debian --distribution bookworm --bootstrap debootstrap

# 2. Desativa updates automáticos para evitar qualquer outra rota quebrada
sudo sed -i 's/LB_SECURITY="true"/LB_SECURITY="false"/' config/common
sudo sed -i 's/LB_UPDATES="true"/LB_UPDATES="false"/' config/common

# 3. Build Real
sudo lb build

# 4. Mover a ISO
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
