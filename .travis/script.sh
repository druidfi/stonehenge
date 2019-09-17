#!/bin/bash

echo "Distribution: ${TRAVIS_DIST}"

make -v
docker --version
docker-compose --version
make debug

# Start up Stonehenge
make up

# Install mkcert
make mkcert-install

# Install SSL-sertificate
if [[ ${TRAVIS_DIST} == 'xenial' ]]; then
  # See https://github.com/FiloSottile/mkcert/pull/193
  sudo make certs
else
  make certs
fi

# Check that we can connect to local Portainer
curl -Is https://portainer.docker.sh | head -1

# Tear down Stonehenge
make down

# Check that DNS work still
curl -Is https://www.google.com | head -1
