#!/usr/bin/env bash

set -eux; \
    apt-get update; \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        lsb-release \
        wget; \
    wget https://packages.sury.org/php/apt.gpg; \
    apt-key add apt.gpg; \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list; \
    apt-get update; \
    apt-get install -y \
        php7.4 \
        php7.4-bcmath \
        php7.4-bz2 \
        php7.4-cli \
        php7.4-common \
        php7.4-curl \
        php7.4-fpm \
        php7.4-gd \
        php7.4-gmp \
        php7.4-intl \
        php7.4-json \
        php7.4-ldap \
        php7.4-mbstring \
        php7.4-mysql \
        php7.4-opcache \
        php7.4-pgsql \
        php7.4-soap \
        php7.4-sqlite3 \
        php7.4-tidy \
        php7.4-xml \
        php7.4-xsl \
        php7.4-zip \
        php-igbinary \
        php-imagick \
        php-redis \
        gettext \
        graphicsmagick \
        unzip; \
    apt-get remove -y python3; \
    apt-get clean -y; \
    apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*; \
    ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm; \
    chmod u+s /usr/sbin/php-fpm; \
    /opt/local/entrypoints/init-local-user.sh;
