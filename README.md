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
*Explica aquí brevemente qué hace este script (comprueba si está instalado, instala sin interacción, habilita el servicio).*

### `setup_selfsigned_certificate.sh`
*Explica aquí brevemente qué hace este script (lee el .env, genera certificado y clave, copia configuraciones, habilita módulos/sitio, testea y reinicia).*

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
```text
[PEGAR AQUÍ LA SALIDA DE LA TERMINAL QUE MUESTRA APACHE ACTIVE Y ENABLED]
```

### Evidencia 2: Reejecución del script de instalación
**Comando ejecutado:**
```bash
sudo ./scripts/install_apache.sh
```
**Resultado:**
```text
[PEGAR AQUÍ LA SALIDA DE LA TERMINAL QUE MUESTRA "Apache ya está instalado"]
```

### Evidencia 3: Sujeto, validez y SAN del certificado
**Comando ejecutado:**
```bash
openssl x509 -in /etc/ssl/certs/apache-selfsigned.crt -noout -subject -dates -ext subjectAltName
```
**Resultado:**
```text
[PEGAR AQUÍ LA SALIDA QUE MUESTRA LOS DATOS DE TU .ENV, LOS 365 DÍAS Y LA IP/DOMINIO]
```

### Evidencia 4: Sintaxis de Apache
**Comando ejecutado:**
```bash
sudo apache2ctl configtest
```
**Resultado:**
```text
[PEGAR AQUÍ LA SALIDA QUE MUESTRA "Syntax OK"]
```

### Evidencia 5: Puertos a la escucha
**Comando ejecutado:**
```bash
sudo ss -tlnp | grep apache2
```
**Resultado:**
```text
[PEGAR AQUÍ LA SALIDA QUE MUESTRA APACHE ESCUCHANDO EN EL 80 Y 443]
```

### Evidencia 6: Redirección HTTP → HTTPS (Desde equipo local)
**Comando ejecutado:**
```bash
curl -I http://practica-https.test
```
**Resultado:**
```text
[PEGAR AQUÍ LA SALIDA QUE MUESTRA EL "HTTP/1.1 301" Y EL "Location: https://..."]
```

### Evidencia 7: Respuesta HTTPS (Desde equipo local)
**Comando ejecutado:**
```bash
curl -kI https://practica-https.test
```
**Resultado:**
```text
[PEGAR AQUÍ LA SALIDA QUE MUESTRA EL "HTTP/1.1 200 OK"]
```

### Evidencia 8: Negociación TLS
**Comando ejecutado:**
```bash
openssl s_client -connect practica-https.test:443 -servername practica-https.test < /dev/null
```
**Resultado:**
```text
[PEGAR AQUÍ EL FRAGMENTO DE LA SALIDA QUE MUESTRA LA VERSIÓN TLS Y EL CERTIFICADO]
```

### Evidencia 9: Acceso desde el Navegador
Acceso a `https://practica-https.test` aceptando el riesgo de CA no confiable.

**Captura del sitio web y detalles del certificado:**

![Captura Navegador](ruta/a/tu/imagen.png) 
*(Nota: Sube la imagen a tu repositorio y sustituye "ruta/a/tu/imagen.png" por el nombre de tu captura, o simplemente arrastra la imagen aquí si estás editando en GitHub web).*