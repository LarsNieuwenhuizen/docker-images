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
        php8.0 \
        php8.0-bcmath \
        php8.0-bz2 \
        php8.0-cli \
        php8.0-common \
        php8.0-curl \
        php8.0-fpm \
        php8.0-gd \
        php8.0-gmp \
        php8.0-intl \
        php8.0-ldap \
        php8.0-mbstring \
        php8.0-mysql \
        php8.0-opcache \
        php8.0-pgsql \
        php8.0-soap \
        php8.0-sqlite3 \
        php8.0-tidy \
        php8.0-xml \
        php8.0-xsl \
        php8.0-zip \
        php-igbinary \
        php-imagick \
        php-redis \
        gettext \
        graphicsmagick \
        unzip; \
    AUTO_ADDED_PACKAGES=`apt-mark showauto`; \
    apt-get remove --purge -y python3 $AUTO_ADDED_PACKAGES; \
    apt-get clean -y; \
    apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*; \
    ln -s /usr/sbin/php-fpm8.0 /usr/sbin/php-fpm; \
    chmod u+s /usr/sbin/php-fpm; \
    /opt/local/entrypoints/init-local-user.sh;
