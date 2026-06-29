FROM debian:bookworm

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y wget && \
    apt-get install -y php8.2 php8.2-fpm php8.2-mysql php8.2-curl php8.2-gd mariadb-client vim zsh git curl && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    mkdir -p /run/php && \
    mkdir -p /var/www/html/wordpress && \
    chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY ./tools/auto_conf.sh /auto_conf.sh

RUN chmod +x auto_conf.sh

CMD ["/auto_conf.sh"]