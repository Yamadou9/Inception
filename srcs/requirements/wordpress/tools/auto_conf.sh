#!/bin/bash

set -e

sleep 5

# Install WP-CLI if not present
if ! command -v wp >/dev/null 2>&1; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

WP_PATH="/var/www/html/wordpress"

mkdir -p "$WP_PATH"
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "[======== WP INSTALLATION STARTED ========]"

# Download WordPress only if missing
if [ ! -f "$WP_PATH/wp-load.php" ]; then
    wp core download --path="$WP_PATH" --allow-root
fi

# Create config only if missing
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    wp core config \
        --path="$WP_PATH" \
        --dbhost=mariadb:3306 \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --allow-root
fi

# Install WordPress only once
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
    wp core install \
        --path="$WP_PATH" \
        --url="http://${DOMAIN_NAME}" \
        --title="$TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --path="$WP_PATH" \
        --allow-root
fi

echo "[======== WP READY ========]"

# PHP-FPM config
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php

exec /usr/sbin/php-fpm7.4 -F -R