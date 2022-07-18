#!/usr/bin/env sh
/entrypoints/init-local-user.sh

php-fpm -F
