ARG TRAEFIK_VERSION=2.7.0

FROM traefik:${TRAEFIK_VERSION}

ARG TARGETARCH

ENV CAROOT=/ssl

RUN wget -O /usr/local/bin/mkcert "https://dl.filippo.io/mkcert/latest?for=linux/${TARGETARCH}"

RUN chmod +x /usr/local/bin/mkcert && \
    mkdir ${CAROOT} && \
    mkcert -install && \
    mkcert -cert-file ${CAROOT}/docker.so.crt -key-file ${CAROOT}/docker.so.key "*.docker.so" && \
    mkcert -cert-file ${CAROOT}/traefik.me.crt -key-file ${CAROOT}/traefik.me.key "*.traefik.me" && \
    ls -lah ${CAROOT}/
