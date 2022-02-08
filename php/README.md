# PHP image
These php images are based on debian.
The build process installs the most commonly used (in my opinion) php packages.

## Versions
- 7.4 as `larsnieuwenhuizen/php-fpm:7.4`
- 7.4-dev as `larsnieuwenhuizen/php-fpm:7.4-dev`
- 8.0 as `larsnieuwenhuizen/php-fpm:8.0`
- 8.0-dev as `larsnieuwenhuizen/php-fpm:8.0-dev`
- 8.1 as `larsnieuwenhuizen/php-fpm:8.1`
- 8.1-dev as `larsnieuwenhuizen/php-fpm:8.1-dev`

## Version pinning
Every minor version is also tagged with the specific patch version on build.
So if you want to use a specific version like 8.1.1 you can use it.

---

## Production
This purely installs the necessary php packages and that's it

## Development
Everything included in the production build, but also installs
- composer
- phpcs
- phpunit
- xdebug
- composer normalize

# Non root usage
A user and group are created by default
user: docker (uid 9001)
group: dockerlocal (gid 9001)

php-fpm pool is configured to start with docker:dockerlocal

I've omitted the USER statement in the dockerfile,
so by default this image runs as root. I'd advice against this in production!

php-fpm is configured to be able to be started by docker (9001).
So to use this image as your own php-fpm container as non root do this:

```dockerfile
FROM larsnieuwenhuizen/php-fpm:8.1

# Add your statements here

USER docker

ENTRYPOINT php-fpm -F
```
