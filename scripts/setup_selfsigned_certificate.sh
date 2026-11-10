#!/bin/bash
set -e

if ! dpkg -s apache2 >/dev/null 2>&1; then
    echo "Error: Apache no está instalado. Ejecuta primero install_apache.sh"
    exit 1
fi

# Cargar variables de entorno del archivo .env
if [ -f "$(dirname "$0")/.env" ]; then
    source "$(dirname "$0")/.env"
else
    echo "Error: No se encuentra el archivo scripts/.env"
    exit 1
fi

echo "Generando certificado autofirmado con OpenSSL..."
sudo openssl req -x509 -nodes -days "$DAYS" -newkey rsa:2048 \
  -keyout "$KEY_PATH" \
  -out "$CRT_PATH" \
  -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN/emailAddress=$EMAIL" \
  -addext "subjectAltName=DNS:$CN,IP:$IP_ELASTICA"

echo "Copiando y ajustando configuraciones de Apache..."
sudo cp conf/000-default.conf /etc/apache2/sites-available/000-default.conf
sudo cp conf/practica-https-ssl.conf /etc/apache2/sites-available/practica-https-ssl.conf

# Reemplazar posibles variables en la configuración si fuera necesario
sudo sed -i "s/practica-https.test/$CN/g" /etc/apache2/sites-available/000-default.conf
sudo sed -i "s/practica-https.test/$CN/g" /etc/apache2/sites-available/practica-https-ssl.conf

echo "Habilitando módulos ssl y rewrite..."
sudo a2enmod ssl rewrite
sudo a2ensite practica-https-ssl.conf

echo "Comprobando sintaxis de Apache..."
if sudo apache2ctl configtest; then
    echo "Sintaxis OK. Reiniciando Apache..."
    sudo systemctl restart apache2
else
    echo "Error de sintaxis en Apache. Abortando reinicio."
    exit 1
fi