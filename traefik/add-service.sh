#!/usr/bin/env sh

if [ $# -lt 2 ]
then
    printf "Missing options!\n\n"
    printf "docker exec stonehenge-traefik add-service name domain [port]\n\n"
    printf "Example:\n"
    printf "docker exec stonehenge-traefik add-service foobar mydomain.com 3003\n"
    printf "This will route https://foobar.mydomain.com to port 3003 of the host\n\n"
    printf "NOTE! foobar.mydomain.com must point to 127.0.0.1\n"
    exit 0
fi

NAME=$1
DOMAIN=$2
HOST="$NAME.$DOMAIN"
HOST_DASHED="${HOST//./-}"
PORT=${3:-3000}
FILENAME="/configuration/$HOST.yml"
ROUTER="$HOST_DASHED-router"
SERVICE="$HOST_DASHED-service"
CERT="/ssl/$DOMAIN"

printf "Creating configuration for local service: https://$HOST --> localhost:$PORT\n\n"

test -f $CERT.crt && echo "- Certificates already exists 👍" || mkcert -cert-file $CERT.crt -key-file $CERT.key "*.${DOMAIN}"

{
  printf 'tls:\n\n'
  printf '  certificates:\n'
  printf '    - certFile: %s.crt\n' "$CERT"
  printf '      keyFile: %s.key\n\n' "$CERT"
  printf 'http:\n\n'
  printf '  routers:\n'
  printf '    %s:\n' "$ROUTER"
  printf '      entrypoints: https\n'
  printf '      rule: Host(`%s`)\n' "$HOST"
  printf '      tls: {}\n'
  printf '      service: %s\n\n' "$SERVICE"
  printf '  services:\n'
  printf '    %s:\n' "$SERVICE"
  printf '      loadBalancer:\n'
  printf '        servers:\n'
  printf '          - url: http://host.docker.internal:%d\n' "$PORT"
} > "$FILENAME"

test -f $FILENAME && echo "- Configuration created 👍"
