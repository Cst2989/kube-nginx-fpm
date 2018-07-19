FROM alpine:edge
LABEL maintainer="Giberish"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk upgrade --no-cache && \
    apk --no-cache add \
        tzdata supervisor nginx php7 php7-fpm php7-pear \
        php7-xml php7-redis php7-bcmath \
        php7-pdo php7-pdo_mysql php7-mysqli php7-mbstring php7-gd php7-mcrypt \
        php7-openssl php7-apcu php7-gmagick php7-xsl php7-zip php7-sockets \
        php7-ldap php7-pdo_sqlite php7-iconv php7-json php7-intl php7-memcached php7-ctype \
        php7-oauth php7-imap php7-gmp \
        g++ make autoconf curl php7-phar bash php7-curl php7-tokenizer php7-opcache && \
    cp /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone && \
    mkdir -p /run/nginx

COPY ./configs/supervisord.conf /etc/supervisord.conf
COPY ./configs/nginx.conf /etc/nginx/nginx.conf
COPY ./configs/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./configs/opcache.ini /etc/php7/conf.d/00_opcache.ini

ADD http://getcomposer.org/installer /tmp/composer-setup.php
RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

EXPOSE 80
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
