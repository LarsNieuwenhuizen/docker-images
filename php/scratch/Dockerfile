FROM alpine:latest as compilation

RUN apk update; \
    apk upgrade; \
    apk add gcc autoconf libc-dev bison re2c make curl gnupg zlib-dev pcre-dev openssl icu-dev g++

ARG PHP_VERSION=8.1
ARG PATCH_VERSION=7
ARG GPG_KEYS="39B641343D8C104B2B146DC3F9C39DC0B9698544 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E F1F692238FBC1666E5A5CCD4199F9DFEF6FFBAFD"

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

RUN curl -fSL https://www.php.net/distributions/php-$PHP_VERSION.$PATCH_VERSION.tar.gz -o php.tar.gz
RUN curl -fSL https://www.php.net/distributions/php-$PHP_VERSION.$PATCH_VERSION.tar.gz.asc -o php.tar.gz.asc

RUN gpg --verify php.tar.gz.asc php.tar.gz

RUN cd /opt && tar -xvzf php.tar.gz

WORKDIR /opt/php-$PHP_VERSION.$PATCH_VERSION

RUN ./buildconf --force

RUN apk add libxml2-dev libxml2 icu oniguruma-dev sqlite-dev libpq-dev

RUN ./configure --disable-all \
    --enable-fpm \
    --with-fpm-user=docker \
    --with-fpm-group=dockerlocal \
    --enable-intl \
    --with-mbstring \
    --with-pgsql \
    --enable-pgsql \
    --with-pdo-pgsql \
    --enable-pdo \
    --enable-mbstring \
    --enable-filter \
    --enable-opcache \
    --enable-soap \
    --with-libxml \
    --enable-xmlreader

RUN make tests

RUN make -j8 && make install

FROM alpine:latest as production

RUN apk add --no-cache libxml2 icu shadow oniguruma sqlite libpq; \
    apk -U upgrade; \
    rm -rf /var/cache/apk/*;

ENV LOCAL_USER_ID=9001
ENV LOCAL_GROUP_ID=9001

COPY --from=compilation  /usr/local/bin/php /usr/local/bin/php
COPY --from=compilation  /usr/local/sbin /usr/local/sbin
COPY --from=compilation  /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY entrypoints /entrypoints
COPY php.ini /usr/local/lib/php.ini
COPY config/php-fpm-pool.conf /usr/local/etc/php-fpm.conf

RUN /entrypoints/init-local-user.sh && chmod -R 777 /var/log && chown -R docker:dockerlocal /run

EXPOSE 9000

USER docker
