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
  DOCKER_BUILDKIT=1 docker build \
      --no-cache \
      --target=production \
      -t larsnieuwenhuizen/php-fpm:${version} \
      --build-arg PHP_VERSION=${version} .

  DOCKER_BUILDKIT=1 docker build \
      --no-cache \
      --target=development \
      -t larsnieuwenhuizen/php-fpm:${version}-dev \
      --build-arg PHP_VERSION="${version}" .

  patchVersion=$(docker run --rm --entrypoint=php larsnieuwenhuizen/php-fpm:${version} -v | pcregrep -o1 "${version}.([0-9]+)" | head -n 1)
  docker tag larsnieuwenhuizen/php-fpm:${version} larsnieuwenhuizen/php-fpm:${version}.${patchVersion}
  docker tag larsnieuwenhuizen/php-fpm:${version}-dev larsnieuwenhuizen/php-fpm:${version}.${patchVersion}-dev
done
