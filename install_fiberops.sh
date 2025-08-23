#!/bin/bash
# ================================================
#   Sistema FiberOps 2025 - Instalación Automática
#   Autor: Yeremi Tantaraico
#   Email: yeremitantaraico@gmail.com
#   Ubuntu Server 22.04
# ================================================

# --- Función para mostrar mensajes bonitos ---
function msg() {
    echo -e "\n\033[1;32m[✔]\033[0m $1\n"
}

# --- 0. Pre-requisitos ---
msg "Deshabilitando IPv6 para evitar problemas de descarga..."
echo -e "precedence ::ffff:0:0/96 100" | sudo tee -a /etc/gai.conf

# --- 1. Actualizar sistema ---
msg "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# --- 2. Instalar Apache ---
msg "Instalando Apache..."
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2

# --- 3. Instalar PHP 8.1 y módulos ---
msg "Instalando PHP 8.1 y módulos necesarios..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php8.1 php8.1-cli php8.1-fpm php8.1-common \
    php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl \
    php8.1-xml php8.1-bcmath php8.1-snmp php8.1-pgsql php8.1-readline -y

sudo update-alternatives --set php /usr/bin/php8.1
sudo apt install libapache2-mod-php8.1 -y
sudo a2enmod php8.1
sudo systemctl restart apache2

php -v

# --- 4. Instalar y habilitar SSH2 ---
msg "Instalando extensión SSH2 para PHP..."
sudo apt install php8.1-dev php-pear libssh2-1-dev libssl-dev build-essential -y
sudo pecl install ssh2-1.3.1 <<EOF
yes
EOF

echo "extension=ssh2.so" | sudo tee /etc/php/8.1/apache2/conf.d/20-ssh2.ini
echo "extension=ssh2.so" | sudo tee /etc/php/8.1/cli/conf.d/20-ssh2.ini
php -m | grep ssh2
sudo systemctl restart apache2

# --- 5. Dependencias SNMP y PostgreSQL ---
msg "Instalando dependencias de SNMP y PostgreSQL..."
sudo apt install snmp snmpd libpq-dev python3-dev python3-pip -y
sudo apt install snmp snmp-mibs-downloader php-snmp -y
pip3 install psycopg2-binary

# --- 5.1 Extensiones y dependencias adicionales ---
msg "Instalando extensiones adicionales (GD, intl, PDO, etc.)..."
# Extensión GD para PHP 8.3
sudo apt install php8.3-gd -y
php -m | grep gd || echo "⚠️ GD no se habilitó correctamente"

# Extensión intl para PHP 8.1
sudo apt install php8.1-intl -y
sudo phpenmod -v 8.1 intl
php -m | grep intl || echo "⚠️ intl no se habilitó correctamente"

# Extensiones PostgreSQL y PDO
sudo apt install php8.3-pgsql php8.3-mbstring php8.3-xml php8.3-zip -y
sudo apt install php8.1-pgsql php8.1-mysql -y
php -m | grep -E "(pdo|pgsql)" || echo "⚠️ Extensiones PDO/PGSQL no cargadas"

# Reiniciar Apache después de nuevas extensiones
sudo systemctl restart apache2

# --- 6. Base de datos PostgreSQL ---
msg "Instalando PostgreSQL..."
sudo apt install postgresql postgresql-contrib -y
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo systemctl status postgresql --no-pager

# --- 7. Instalar Composer ---
msg "Instalando Composer..."
sudo apt install composer -y

# --- 8. Preparar directorio del proyecto ---
msg "Preparando directorio de FiberOps..."
cd /var/www/html/
sudo mkdir -p /var/www/html/
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 777 /var/www/html/
sudo mkdir -p /var/www/html/logs
sudo chmod -R 777 /var/www/html/logs

# --- 9. Instalar dependencias PHP del proyecto ---
msg "Instalando dependencias PHP del proyecto..."
cd /var/www/html/
composer install || true

# --- 10. Configurar Apache ---
msg "Configurando Apache..."
sudo phpenmod snmp
sudo a2enmod rewrite
sudo systemctl restart apache2

# --- 11. Configurar zona horaria ---
msg "Configurando zona horaria a Perú..."
sudo timedatectl set-timezone America/Lima
timedatectl | grep "Time zone"

# --- Fin ---
msg "✅ Instalación completada con éxito.
Sistema FiberOps 2025 instalado en /var/www/html/
Ahora puedes desplegar tu código en esa carpeta."
