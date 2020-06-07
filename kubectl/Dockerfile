FROM alpine:latest

RUN set -eux; \
    apk update; \
    apk upgrade; \
    apk add --no-cache ca-certificates curl; \
    update-ca-certificates --fresh; \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl; \
    chmod +x ./kubectl; \
    mkdir -p /home/kubectl/.kube; \
    addgroup -g 998 -S kubectl; \
    adduser -u 998 -D -G kubectl -h /home/kubectl -S kubectl; \
    mkdir /home/kubectl/bin; \
    mv ./kubectl /home/kubectl/bin; \
    chown -R kubectl:kubectl /home/kubectl

ENV PATH="/home/kubectl/bin:$PATH"

USER kubectl

WORKDIR /home/kubectl

ENTRYPOINT ["kubectl"]
