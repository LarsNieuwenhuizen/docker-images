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

docker pull debian:bullseye-slim

# Build images
for version in ${buildVersions[*]}; do
  DOCKER_BUILDKIT=1 docker buildx build \
      --platform linux/amd64,linux/arm64 \
      --target=production \
      -t larsnieuwenhuizen/php-fpm:${version} \
      --build-arg PHP_VERSION=${version} --push .

  DOCKER_BUILDKIT=1 docker buildx build \
      --platform linux/amd64,linux/arm64 \
      --target=development \
      -t larsnieuwenhuizen/php-fpm:${version}-dev \
      --build-arg PHP_VERSION="${version}" --push .
done
