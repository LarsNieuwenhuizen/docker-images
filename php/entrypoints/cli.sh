#!/usr/bin/env bash

exec /bin/su docker -c "/usr/bin/php $@"
