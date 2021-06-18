#!/usr/bin/env bash

set -eu;

supportedVersions=('7.4' '8.0')
buildVersions=()

for version in $@; do
  if ! [[ ${supportedVersions[*]} =~ $version ]]; then
    echo "PHP Version ${version} is not supported to build"
    exit 1
  fi

  buildVersions+=("${version}")
done

if [ ${#buildVersions[@]} -eq 0 ]; then
  buildVersions=( "${supportedVersions[@]}" )
fi

# Build images
for version in ${buildVersions[*]}; do
  docker push larsnieuwenhuizen/php-fpm:${version}
  docker push larsnieuwenhuizen/php-fpm:${version}-dev
done
