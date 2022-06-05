#!/usr/bin/env bash

set -eu;

supportedVersions=('7.4' '8.0' '8.1')
buildVersions=('8.1')

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

docker pull debian:bullseye-slim

# Build images
for version in ${buildVersions[*]}; do
  DOCKER_BUILDKIT=1 docker build --no-cache --target=base --build-arg PHP_VERSION=${version} -t larsnieuwenhuizen/php-fpm:base .

  patchVersion=$(docker run --rm --entrypoint=php larsnieuwenhuizen/php-fpm:base -v | pcregrep -o1 "${version}.([0-9]+)" | head -n 1)

  DOCKER_BUILDKIT=1 docker buildx build \
      --platform linux/amd64,linux/arm64 \
      --target=production \
      -t larsnieuwenhuizen/php-fpm:${version} \
      -t larsnieuwenhuizen/php-fpm:${version}.${patchVersion} \
      --build-arg PHP_VERSION=${version} --push .

  DOCKER_BUILDKIT=1 docker buildx build \
      --platform linux/amd64,linux/arm64 \
      --target=development \
      -t larsnieuwenhuizen/php-fpm:${version}-dev \
      -t larsnieuwenhuizen/php-fpm:${version}.${patchVersion}-dev \
      --build-arg PHP_VERSION="${version}" --push .
done
