#!/bin/bash

pre_actions () {
  if [[ "$DISTRO" == "ubuntu" ]]; then
    #echo "$DISTRO $VERSION does not need extra resolver modifications..."
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
