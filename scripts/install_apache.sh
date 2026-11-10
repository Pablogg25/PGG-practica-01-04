#!/bin/bash
set -e

if dpkg -s apache2 >/dev/null 2>&1; then
    echo "Apache ya está instalado."
    exit 0
fi

echo "Instalando Apache..."
sudo apt update -y
sudo apt install -y apache2

sudo systemctl enable apache2
sudo systemctl start apache2

echo "Apache instalado y activo correctamente."