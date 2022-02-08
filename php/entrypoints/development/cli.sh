#!/usr/bin/env bash
/opt/local/entrypoints/development/init-development-user.sh

exec /bin/su development -c "/usr/bin/php $@"
