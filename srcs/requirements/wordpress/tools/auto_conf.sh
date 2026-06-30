#!/bin/bash

set -e


WP_PATH="/var/www/html/wordpress"

until mysqladmin ping -h mariadb --silent 2>/dev/null; do
    echo "waiting for mariadb..."
    sleep 2
done


mkdir -p "$WP_PATH"
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "[======== WP INSTALLATION STARTED ========]"

if [ ! -f "$WP_PATH/wp-load.php" ]; then
    wp core download --path="$WP_PATH" --allow-root
fi

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    wp core config \
        --path="$WP_PATH" \
        --dbhost=mariadb:3306 \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --allow-root
fi

if ! wp core is-installed --path="$WP_PATH" --allow-root; then
    wp core install \
        --path="$WP_PATH" \
        --url="https://${DOMAIN_NAME}" \
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

mkdir -p /run/php

exec /usr/sbin/php-fpm8.2 -F -R