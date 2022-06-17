ARG TRAEFIK_VERSION=2.7.0

FROM traefik:${TRAEFIK_VERSION}

LABEL org.opencontainers.image.authors="Druid".fi maintainer="Druid.fi"
LABEL org.opencontainers.image.source="https://github.com/druidfi/stonehenge" repository="https://github.com/druidfi/stonehenge"

ARG TARGETARCH

ENV CAROOT=/ssl

RUN wget -O /usr/local/bin/mkcert "https://dl.filippo.io/mkcert/latest?for=linux/${TARGETARCH}"

RUN chmod +x /usr/local/bin/mkcert && \
    mkdir ${CAROOT} && \
    mkcert -install && \
    mkcert -cert-file ${CAROOT}/docker.so.crt -key-file ${CAROOT}/docker.so.key "*.docker.so" && \
    mkcert -cert-file ${CAROOT}/traefik.me.crt -key-file ${CAROOT}/traefik.me.key "*.traefik.me" && \
    ls -lah ${CAROOT}/

# Traefik general configuration
COPY traefik/traefik.yml /traefik.yml
COPY traefik/entrypoint.sh /entrypoint.sh
COPY traefik/dynamic/traefik.dynamic.yml /configuration/traefik.dynamic.yml

# Add scripts
COPY traefik/add-service.sh /usr/local/bin/add-service
COPY traefik/remove-service.sh /usr/local/bin/remove-service

# Copy Mailhog binary
COPY --from=druidfi/mailhog:1.0.1 /bin/MailHog /usr/local/bin/

# Expose the SMTP and HTTP ports used by default by MailHog:
EXPOSE 1025 8025
