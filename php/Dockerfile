ARG CONTEXT=production

##
## baseimage
##
FROM debian:buster-slim AS base

ARG PHP_VERSION=7.4
ARG DEBIAN_FRONTEND=noninteractive

ADD entrypoints /opt/local/entrypoints
ADD installers /opt/local/installers

RUN /opt/local/installers/${PHP_VERSION}.sh; \
    rm -rf /opt/local/installers;

##
## development images
##
FROM base AS development

ARG PHP_VERSION=7.4
ARG DEBIAN_FRONTEND=noninteractive

# Install composer
COPY --from=composer:2.1 /usr/bin/composer /usr/bin/composer

ENV COMPOSER_CACHE_DIR="/var/cache/composer"
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN set -eux; \
    apt-get update; \
    apt-get install -y \
        php-xdebug git; \
    apt-get autoremove -y; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*; \
    composer global require "squizlabs/php_codesniffer"; \
    composer global require "phpunit/phpunit"; \
    composer global require "localheinz/composer-normalize"; \
    rm -rf /var/cache/composer/*;

COPY php-fpm-pool.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY php.ini /etc/php/${PHP_VERSION}/conf.d/9999-php.ini

ENTRYPOINT ["/opt/local/entrypoints/entrypoint-cli.sh"]

FROM base AS production

ENTRYPOINT ["/usr/bin/php"]

##
## Actual output image
##
FROM ${CONTEXT}

MAINTAINER Lars Nieuwenhuizen
