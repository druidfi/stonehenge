ARG TRAEFIK_VERSION=2.8.0

FROM traefik:${TRAEFIK_VERSION}

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/stonehenge" repository="https://github.com/druidfi/stonehenge"

ARG TARGETARCH
ARG USER=druid
ARG UID=1000

ENV CAROOT=/ssl
ENV SOCKET_DIR=/tmp/${USER}_ssh-agent
ENV SSH_AUTH_SOCK=${SOCKET_DIR}/socket
ENV SSH_AUTH_PROXY_SOCK=${SOCKET_DIR}/proxy-socket

RUN wget -O /usr/local/bin/mkcert "https://dl.filippo.io/mkcert/latest?for=linux/${TARGETARCH}"

RUN apk --update --no-cache add nginx openssh socat sudo && \
    adduser -D -u ${UID} ${USER} && \
    mkdir ${SOCKET_DIR} && chown ${USER} ${SOCKET_DIR} && \
    chmod +x /usr/local/bin/mkcert && \
    mkdir ${CAROOT} && \
    mkcert -install && \
    mkcert -cert-file ${CAROOT}/docker.so.crt -key-file ${CAROOT}/docker.so.key "*.docker.so" && \
    mkcert -cert-file ${CAROOT}/traefik.me.crt -key-file ${CAROOT}/traefik.me.key "*.traefik.me"

# Traefik general configuration
COPY traefik/traefik.yml /traefik.yml
COPY traefik/entrypoint.sh /entrypoint.sh
COPY traefik/dynamic/traefik.dynamic.yml /configuration/traefik.dynamic.yml

# Add scripts
COPY traefik/add-service.sh /usr/local/bin/add-service
COPY traefik/remove-service.sh /usr/local/bin/remove-service

# Copy Mailhog binary
COPY --from=druidfi/mailhog:1.0.1 /bin/MailHog /usr/local/bin/

# Copy Catch-all confs
COPY catchall/nginx.conf /etc/nginx/http.d/default.conf
COPY catchall/index.html /usr/share/nginx/html/index.html

# Expose the SMTP and HTTP ports used by default by MailHog:
EXPOSE 1025 8025

VOLUME ${SOCKET_DIR}
