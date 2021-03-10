#!/usr/bin/env bash
/opt/local/entrypoints/init-local-user.sh

exec /bin/su docker -c "/usr/bin/php $@"
