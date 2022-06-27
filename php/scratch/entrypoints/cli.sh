#!/usr/bin/env sh

exec /bin/su docker -c "/usr/local/bin/php $@"
