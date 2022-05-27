#!/usr/bin/env sh

ID=$1
HOST="$ID.${3:-traefik.me}"
HOST_DASHED="${HOST//./-}"
PORT=${2:-3000}
FILENAME="/configuration/$HOST.yml"
ROUTER="$HOST_DASHED-router"
SERVICE="$HOST_DASHED-service"

{
  printf 'http:\n\n'
  printf '  routers:\n'
  printf '    %s:\n' "$ROUTER"
  printf '      rule: Host(`%s`)\n' "$HOST"
  printf '      tls: {}\n'
  printf '      service: %s\n\n' "$SERVICE"
  printf '  services:\n'
  printf '    %s:\n' "$SERVICE"
  printf '      loadBalancer:\n'
  printf '        servers:\n'
  printf '          - url: http://host.docker.internal:%d\n' "$PORT"
} > "$FILENAME"
