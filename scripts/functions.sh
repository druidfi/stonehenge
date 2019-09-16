#!/bin/bash

get_distribution () {
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "darwin"
  elif [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release && echo "${ID}"
  else
    echo "linux"
  fi
}

pre_actions () {
  if [[ -f "/etc/resolv.conf" ]]; then
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
