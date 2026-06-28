FROM debian:bullseye

RUN apt update -y && apt upgrade -y \
&& apt-get install mariadb-server -y \
&& mkdir -p /run/mysqld \
&& chown -R mysql:mysql /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/mariadb.sh /

RUN chmod 777 mariadb.sh

CMD ["/mariadb.sh"]