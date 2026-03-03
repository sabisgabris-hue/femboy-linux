#!/bin/bash
# Garantir pacotes básicos
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# 1. Gerar a configuração básica (apenas o que ele aceita)
sudo lb config --mode debian --distribution bookworm --bootstrap debootstrap

# 2. EDIÇÃO CIRÚRGICA: Desativar segurança e updates direto no arquivo gerado
# Isso evita o erro de 'unrecognized option' e o erro 404 do log
sudo sed -i 's/LB_SECURITY="true"/LB_SECURITY="false"/' config/common
sudo sed -i 's/LB_UPDATES="true"/LB_UPDATES="false"/' config/common

# 3. Adicionar as áreas de repositório manualmente no arquivo
sudo sed -i 's/LB_ARCHIVE_AREAS="main"/LB_ARCHIVE_AREAS="main contrib non-free non-free-firmware"/' config/common

# 4. Inicia o build real
sudo lb build

# Exportar para a pasta que o GitHub vê
mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "A ISO ainda não apareceu"

​<!-- end list -->
