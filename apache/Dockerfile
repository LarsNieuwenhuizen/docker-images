FROM httpd:alpine

RUN apk update && apk add gettext && rm -rf /var/cache/apk
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

EXPOSE 80 443
