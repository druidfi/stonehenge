#!/bin/bash

function get_distribution() {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "osx"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    echo $ID
  fi
}

function get_compose_files() {
  FILES=
  # We have a specific docker-compose file to bind dnsmasq service on
  # 127.0.0.48 (instead of the default 0.0.0.0), due to systemd-resolved
  # using the 53 port on 0.0.0.0.
  if [[ $(uname) == "Linux" ]]; then
    FILES=" -f docker-compose-linux.yml"
  else
    # We can't add dnsmasq service to default docker-compose.yml file, because
    # compose will attempt to reserve all defined ports when chaining multiple
    # compose files.
    FILES=" -f docker-compose-default.yml"
  fi

  # Distribution specific compose.
  if [[ -f "docker-compose-$DISTRO.yml" ]]; then
    FILES="$FILES -f docker-compose-$DISTRO.yml"
  fi
  echo ${FILES}
}
