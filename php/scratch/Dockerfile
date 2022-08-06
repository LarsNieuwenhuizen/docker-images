FROM alpine:latest as compilation

ARG DEVELOPMENT_BUILD=FALSE

ARG PHP_VERSION=8.1
ARG PATCH_VERSION=9
ARG GPG_KEYS="39B641343D8C104B2B146DC3F9C39DC0B9698544 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E F1F692238FBC1666E5A5CCD4199F9DFEF6FFBAFD"
ARG IGBINARY_VERSION=3.2.7
ARG IMAGICK_VERSION=3.7.0
ARG REDIS_VERSION=5.3.7

ENV CONFIGURE_OPTIONS=" \
    --disable-all \
    --enable-bcmath \
    --enable-calendar \
    --with-curl \
    --enable-ctype \
    --enable-dom \
    --enable-exif \
    --with-ffi \
    --enable-fileinfo \
    --enable-filter \
    --enable-ftp \
    --enable-fpm \
    --with-fpm-user=docker \
    --with-fpm-group=dockerlocal \
    --enable-gd \
    --with-gettext \
    --with-gmp \
    --with-iconv \
    --with-igbinary \
    --enable-intl \
    --with-ldap \
    --with-libxml \
    --enable-mbstring \
    --enable-opcache \
    --with-openssl \
    --with-mysqli \
    --enable-pcntl \
    --enable-pdo \
    --with-pdo-pgsql \
    --with-pdo-mysql \
    --with-pdo-sqlite \
    --with-pgsql \
    --enable-pgsql \
    --with-readline \
    --enable-posix \
    --enable-session \
    --enable-shmop \
    --enable-simplexml \
    --enable-soap \
    --with-sodium \
    --enable-sockets \
    --enable-sqlite3 \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-tokenizer \
    --with-tidy \
    --enable-xml \
    --enable-xmlreader \
    --enable-xmlwriter \
    --with-xsl \
    --with-bz2 \
    --with-zip \
    --with-zlib \
"

ENV DEVELOPMENT_CONFIGURE_OPTIONS=" \
    --enable-phar \
    --enable-debug \
    --enable-phpdbg \
"


RUN if [[ $DEVELOPMENT_BUILD ]];  \
    then \
      export CONFIGURE_OPTIONS="$CONFIGURE_OPTIONS $DEVELOPMENT_CONFIGURE_OPTIONS"; \
    fi


ENV DEV_BUILD_REQS=" \
    bzip2-dev  \
    curl-dev \
    gettext-dev  \
    gmp-dev  \
    icu-dev  \
    libc-dev  \
    libffi-dev  \
    imagemagick-dev \
    libsodium-dev  \
    libxml2-dev  \
    libpng-dev  \
    libxslt-dev  \
    libzip-dev  \
    oniguruma-dev  \
    openldap-dev  \
    pcre-dev  \
    readline-dev  \
    sqlite-dev  \
    libpq-dev \
    tidyhtml-dev \
    zlib-dev \
"

ENV BASE_REQS="\
    autoconf  \
    bison  \
    bzip2  \
    curl \
    gcc  \
    gnupg  \
    g++ \
    icu  \
    openssl  \
    make  \
    re2c \
"

RUN apk update; \
    apk upgrade; \
    apk add --no-cache $DEV_BUILD_REQS \
    $BASE_REQS

RUN found='' \
    && for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
		hkp://p80.pool.sks-keyservers.net:80 \
		pgp.mit.edu \
	; do \
		echo "Fetching GPG key $GPG_KEYS from $server"; \
		gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys $GPG_KEYS && found=yes && break; \
    done

RUN if [ $found == "yes" ]; then \
      echo "ok" \
    else \
     echo "Keys not found" && exit 1; \
    fi

WORKDIR /opt

RUN curl -fSL https://www.php.net/distributions/php-$PHP_VERSION.$PATCH_VERSION.tar.gz -o php.tar.gz; \
    curl -fSL https://www.php.net/distributions/php-$PHP_VERSION.$PATCH_VERSION.tar.gz.asc -o php.tar.gz.asc; \
    gpg --verify php.tar.gz.asc php.tar.gz; \
    cd /opt && tar -xvzf php.tar.gz

WORKDIR /opt/php-$PHP_VERSION.$PATCH_VERSION

RUN ./buildconf --force

RUN ./configure $CONFIGURE_OPTIONS

RUN make tests

RUN make -j8 && make install

# Note: build igbinary, imagemagick & redis extension from source
RUN export IGBINARY_BUILD_DIR=$(mktemp -d); \
    cd $IGBINARY_BUILD_DIR; \
    wget https://github.com/igbinary/igbinary/archive/refs/tags/$IGBINARY_VERSION.tar.gz; \
    tar -xvzf $IGBINARY_VERSION.tar.gz; \
    cd igbinary-$IGBINARY_VERSION; \
    phpize; \
    ./configure CFLAGS="-O2 -g" --enable-igbinary; \
    make; \
    make install; \
    \
    export IMAGICK_BUILD_DIR=$(mktemp -d); \
    cd $IMAGICK_BUILD_DIR; \
    wget https://github.com/Imagick/imagick/archive/refs/tags/$IMAGICK_VERSION.tar.gz; \
    tar -xvzf $IMAGICK_VERSION.tar.gz; \
    cd imagick-$IMAGICK_VERSION; \
    phpize; \
    ./configure; \
    make; \
    make install; \
    \
    export REDIS_BUILD_DIR=$(mktemp -d); \
    cd $REDIS_BUILD_DIR; \
    wget https://github.com/phpredis/phpredis/archive/refs/tags/$REDIS_VERSION.tar.gz; \
    tar -xvzf $REDIS_VERSION.tar.gz; \
    cd phpredis-$REDIS_VERSION; \
    phpize; \
    ./configure; \
    make; \
    make install

RUN apk del $BASE_REQS

######################################
#   PRODUCTION IMAGE                 #
######################################
FROM alpine:latest as production

ENV LOCAL_USER_ID=9001
ENV LOCAL_GROUP_ID=9001

COPY --from=compilation  /usr/local/bin/php /usr/local/bin/php
COPY --from=compilation  /usr/local/sbin /usr/local/sbin
COPY --from=compilation  /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=compilation  /usr/lib /usr/lib

COPY entrypoints /entrypoints
COPY php.ini /usr/local/lib/php.ini
COPY config/php-fpm-pool.conf /usr/local/etc/php-fpm.conf

RUN apk -U upgrade; \
    rm -rf /var/cache/apk/*; \
    /entrypoints/init-local-user.sh &&  \
    chmod -R 777 /var/log && \
    chown -R docker:dockerlocal /run

EXPOSE 9000

USER docker

######################################
#   DEVELOPMENT IMAGE                #
######################################
FROM production as development

COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer

USER root
