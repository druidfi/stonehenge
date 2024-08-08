ARG MAILPIT_VERSION=1.20.0

#
# Mailpit binary
#
FROM golang:alpine AS mailpit-builder

ARG MAILPIT_VERSION
WORKDIR /app

ADD https://github.com/axllent/mailpit/archive/refs/tags/v${MAILPIT_VERSION}.tar.gz .

RUN apk add --no-cache git npm
RUN tar --strip-components=1 -zxf v${MAILPIT_VERSION}.tar.gz -C .
RUN npm install && npm run package
RUN CGO_ENABLED=0 go build -ldflags "-s -w -X github.com/axllent/mailpit/config.Version=${MAILPIT_VERSION}" -o /mailpit

#
# Stonehenge
#
FROM traefik:3.1.2 AS stonehenge

ARG MAILPIT_VERSION
ARG TARGETARCH
ARG USER=druid
ARG UID=1000

ENV CAROOT=/ssl
ENV SOCKET_DIR=/tmp/${USER}_ssh-agent
ENV SSH_AUTH_SOCK=${SOCKET_DIR}/socket
ENV SSH_AUTH_PROXY_SOCK=${SOCKET_DIR}/proxy-socket
ENV MAILPIT_VERSION=${MAILPIT_VERSION}

RUN wget -O /usr/local/bin/mkcert "https://dl.filippo.io/mkcert/latest?for=linux/${TARGETARCH}"

RUN apk --update --no-cache add bind-tools nginx openssh socat sudo tzdata && \
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

# Copy Mailpit binary
COPY --from=mailpit-builder /mailpit /usr/local/bin/

# Copy Catch-all confs
COPY catchall/nginx.conf /etc/nginx/http.d/default.conf
COPY catchall/index.html /usr/share/nginx/html/index.html

# Expose the SMTP and HTTP ports used by default by Mailpit:
EXPOSE 1025/tcp 8025/tcp

VOLUME ${SOCKET_DIR}
