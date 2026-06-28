FROM debian:11

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y wget && \
    apt-get install -y php7.3 php-fpm php-mysql mariadb-client vim zsh git curl && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    mkdir -p /run/php && \
    mkdir -p /var/www/html/wordpress && \
    chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

COPY /tools/auto_conf.sh /

RUN chmod +x auto_conf.sh

CMD ["./auto_conf.sh"]