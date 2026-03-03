#!/bin/bash
for i in {1..3}; do sudo apt-get update && break || sleep 5; done
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools cpio --fix-missing

set -e
mkdir -p /tmp/femboy_factory && cd /tmp/femboy_factory
sudo lb clean --purge || true

# 1. Configuração mínima (só o que ele aceita com certeza)
sudo lb config --mode debian --distribution bookworm --bootstrap debootstrap

# 2. O PULO DO GATO: Desativar segurança e updates direto no arquivo
# Isso evita o erro de 'unrecognized option' e o erro 404
echo "LB_SECURITY='false'" | sudo tee -a config/common
echo "LB_UPDATES='false'" | sudo tee -a config/common

# 3. Inicia o build real
sudo lb build

mkdir -p $GITHUB_WORKSPACE/output
sudo mv *.iso $GITHUB_WORKSPACE/output/ 2>/dev/null || echo "ISO ainda não gerada"
​<!-- end list -->
