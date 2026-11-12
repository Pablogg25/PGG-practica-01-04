# Práctica 1.4 — HTTPS con certificado autofirmado en Apache

**Alumno:** Pablo González García
**Módulo:** Despliegue de Aplicaciones Web (DAW2)

---

## 1. Preparación del Entorno (Pasos previos manuales)
Antes de ejecutar los scripts, se han realizado las siguientes acciones manuales:
1. Creación de instancia EC2 (Ubuntu Server LTS, t2.micro).
2. Configuración del Security Group permitiendo tráfico SSH (22), HTTP (80) y HTTPS (443).
3. Asignación de una IP Elástica a la instancia.
4. Clonación de este repositorio en la instancia.
5. Configuración del archivo `/etc/hosts` en la máquina local (anfitrión) apuntando el dominio `practica-https.test` a la IP Elástica.

---

## 2. Explicación de los Scripts

### `install_apache.sh`
Este script automatiza la instalación y puesta en marcha del servidor web Apache en Ubuntu Server:
* Verifica mediante `dpkg` si el paquete `apache2` ya se encuentra instalado en el sistema para evitar ejecuciones redundantes (idempotencia).
* Si no está instalado, actualiza los repositorios (`apt update`) e instala Apache de forma desatendida (`-y`).
* Habilita el servicio para que arranque automáticamente con el sistema (`systemctl enable apache2`) y lo inicia (`systemctl start apache2`).

### `setup_selfsigned_certificate.sh`
Este script configura el entorno HTTPS mediante un certificado SSL/TLS autofirmado:
* Carga las variables de entorno definidas en `scripts/.env` (país, provincia, localidad, organización, dominio, IP elástica y rutas).
* Genera una clave privada RSA de 2048 bits y un certificado autofirmado X.509 válido por 365 días mediante `openssl`, incluyendo la extensión **SAN (Subject Alternative Name)** tanto para el dominio `practica-https.test` como para la IP Elástica.
* Copia los archivos de configuración de los Virtual Hosts HTTP y HTTPS a `/etc/apache2/sites-available/`.
* Activa los módulos `ssl` y `rewrite`, habilita los nuevos sitios virtuales y deshabilita el sitio por defecto (`000-default.conf`).
* Valida la sintaxis de configuración (`apache2ctl configtest`) y reinicia el servicio de Apache para aplicar los cambios.

---

## 3. Verificación y Evidencias

A continuación se muestran las pruebas de funcionamiento requeridas tras la ejecución de los scripts.

### Evidencia 1: Instalación de Apache
**Comando ejecutado:**
```bash
sudo ./scripts/install_apache.sh
systemctl status apache2
```
**Resultado:**
![Apache Active/Enabled](Evidencias/Evidencia1.png)

### Evidencia 2: Reejecución del script de instalación
**Comando ejecutado:**
```bash
sudo ./scripts/install_apache.sh
```
**Resultado:**
![Apache Instalado](Evidencias/Evidencia2.png)

### Evidencia 3: Sujeto, validez y SAN del certificado
**Comando ejecutado:**
```bash
openssl x509 -in /etc/ssl/certs/apache-selfsigned.crt -noout -subject -dates -ext subjectAltName
```
**Resultado:**
![ENV](Evidencias/Evidencia3.png)

### Evidencia 4: Sintaxis de Apache
**Comando ejecutado:**
```bash
sudo apache2ctl configtest
```
**Resultado:**
![Syntax OK](Evidencias/Evidencia4.png)

### Evidencia 5: Puertos a la escucha
**Comando ejecutado:**
```bash
sudo ss -tlnp | grep apache2
```
**Resultado:**
![Puertos 80 y 443](Evidencias/Evidencia5.png)

### Evidencia 6: Redirección HTTP → HTTPS (Desde equipo local)
**Comando ejecutado:**
```bash
curl -I http://practica-https.test
```
**Resultado:**
![Location](Evidencias/Evidencia6.png)

### Evidencia 7: Respuesta HTTPS (Desde equipo local)
**Comando ejecutado:**
```bash
curl -kI https://practica-https.test
```
**Resultado:**
![HTTP 200 OK](Evidencias/Evidencia7.png)

### Evidencia 8: Negociación TLS
**Comando ejecutado:**
```bash
openssl s_client -connect practica-https.test:443 -servername practica-https.test < /dev/null
```
**Resultado:**
![TLS Y CERTIFICADO](Evidencias/Evidencia8.png)

### Evidencia 9: Acceso desde el Navegador
Acceso a `https://practica-https.test` aceptando el riesgo de CA no confiable.

**Captura del sitio web y detalles del certificado:**
![Detalles del certificado en Firefox](Evidencias/Evidencia9.png)
![Web cargada por HTTPS](Evidencias/Evidencia9-1.png)
