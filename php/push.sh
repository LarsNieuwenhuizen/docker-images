#!/usr/bin/env bash

set -eu;

supportedVersions=('7.4' '8.0' '8.1')
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
  patchVersion=$(docker run --rm --entrypoint=php larsnieuwenhuizen/php-fpm:${version} -v | pcregrep -o1 "${version}.([0-9]+)" | head -n 1)

  docker push larsnieuwenhuizen/php-fpm:${version}
  docker push larsnieuwenhuizen/php-fpm:${version}.${patchVersion}
  docker push larsnieuwenhuizen/php-fpm:${version}-dev
  docker push larsnieuwenhuizen/php-fpm:${version}.${patchVersion}-dev
done
