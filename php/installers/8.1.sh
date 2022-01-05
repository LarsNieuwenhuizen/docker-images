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
        php8.1 \
        php8.1-bcmath \
        php8.1-bz2 \
        php8.1-cli \
        php8.1-common \
        php8.1-curl \
        php8.1-fpm \
        php8.1-gd \
        php8.1-gmp \
        php8.1-intl \
        php8.1-ldap \
        php8.1-mbstring \
        php8.1-mysql \
        php8.1-opcache \
        php8.1-pgsql \
        php8.1-soap \
        php8.1-sqlite3 \
        php8.1-tidy \
        php8.1-xml \
        php8.1-xsl \
        php8.1-zip \
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
    ln -s /usr/sbin/php-fpm8.1 /usr/sbin/php-fpm; \
    chmod u+s /usr/sbin/php-fpm; \
    /opt/local/entrypoints/init-local-user.sh;
