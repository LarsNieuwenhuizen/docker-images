#!/usr/bin/env bash
/opt/local/entrypoints/development/init-development-user.sh

exec /bin/su docker -c "/usr/bin/php $@"
