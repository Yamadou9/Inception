#!/bin/sh
set -e

mysqld_safe --skip-networking &

until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

# N'init que si la DB n'existe pas déjà
if ! mysql -u root -p"${SQL_ROOT_PASSWORD}" -e "USE \`${SQL_DATABASE}\`;" 2>/dev/null; then
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

exec mysqld --user=mysql