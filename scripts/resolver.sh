#!/bin/bash

shopt -s xpg_echo

. ./scripts/os.sh
DISTRO=$(get_distribution)

# Load env file
# shellcheck disable=SC1091
. .env

read -r -d '' RESOLVER_BODY_DARWIN << EOM
# Generated by druidfi/stonehenge
nameserver 127.0.0.1
port 53
EOM

read -r -d '' RESOLVER_BODY_LINUX << EOM
# Generated by druidfi/stonehenge
nameserver 127.0.0.48
EOM

install () {
  if [[ "$DISTRO" == "osx" ]]; then
    test -d /etc/resolver || sudo mkdir -p /etc/resolver
    sudo sh -c "echo '$RESOLVER_BODY_DARWIN' > /etc/resolver/$DOCKER_DOMAIN" && echo "Resolver file created"
    exit 0
  fi

  if [[ "$DISTRO" == "ubuntu" ]]; then
    echo "$DISTRO does not need extra resolver modifications..."
    exit 0
  elif [[ -f "/etc/resolv.conf" ]]; then
    ORIGINAL=$(cat /etc/resolv.conf)
    # Backup original resolv.conf, add our local nameserver as first.
    sudo cp /etc/resolv.conf /etc/resolv.conf.default

    if grep -q "druidfi/stonehenge" /etc/resolv.conf; then
      sudo sh -c "printf '$RESOLVER_BODY_LINUX\n$ORIGINAL' > /etc/resolv.conf"
    fi
    exit 0
  fi

  echo "Unknown distribution. You might need to handle name resolver settings manually."
  exit 0
}

remove() {
  if [[ "$DISTRO" == "osx" ]]; then
    sudo rm -f "/etc/resolver/${DOCKER_DOMAIN}" && echo "Resolver file removed" || echo "Already removed"
  else
    if [[ -f "/etc/resolv.conf.default" ]]; then
      # Remove our resolv.conf and replace with old.
      sudo rm /etc/resolv.conf && sudo mv /etc/resolv.conf.default /etc/resolv.conf
    fi
  fi
}
