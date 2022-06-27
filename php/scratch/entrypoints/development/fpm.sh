#!/usr/bin/env sh
/entrypoints/development/init-development-user.sh

php-fpm -F
