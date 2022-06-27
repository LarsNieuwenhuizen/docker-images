#!/usr/bin/env sh
/entrypoints/development/init-development-user.sh

exec /bin/su development -c "/usr/bin/php $@"
