FROM debian:bullseye-slim AS base
ARG PHP_VERSION=7.4
ARG LATEST_PHP_VERSION=8.1
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get upgrade -y; \
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
    apt-get install -y php${PHP_VERSION}

##
## Production
##
FROM base AS production

ARG PHP_VERSION=7.4
ARG LATEST_PHP_VERSION=8.1
ARG DEBIAN_FRONTEND=noninteractive

COPY entrypoints /opt/local/entrypoints
COPY installers /opt/local/installers

RUN /opt/local/installers/${PHP_VERSION}.sh; \
    rm -rf /opt/local/installers; \
    update-alternatives --set php /usr/bin/php${PHP_VERSION}

RUN if [ "$PHP_VERSION" != "$LATEST_PHP_VERSION" ]; then \
    apt-get purge -y php${LATEST_PHP_VERSION}*; \
fi

##
## Development
##
FROM production AS development

ARG PHP_VERSION=7.4
ARG DEBIAN_FRONTEND=noninteractive

# Install composer
COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer

ENV COMPOSER_CACHE_DIR="/var/cache/composer"
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        php${PHP_VERSION}-xdebug git; \
    apt-get autoremove -y; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*; \
    composer global require "squizlabs/php_codesniffer"; \
    composer global require "phpunit/phpunit"; \
    composer global require --no-plugins "localheinz/composer-normalize"; \
    rm -rf /var/cache/composer/*; \
    chmod -R 777 /var/cache/composer

COPY php-fpm-pool.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY php.ini /etc/php/${PHP_VERSION}/conf.d/9999-php.ini

ENTRYPOINT ["/opt/local/entrypoints/cli.sh"]

MAINTAINER Lars Nieuwenhuizen
