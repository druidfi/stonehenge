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
sudo make certs

# Check that we can connect to local Portainer
curl -Is https://portainer.docker.sh | head -1

# Tear down Stonehenge
make down

# Check that DNS work still
curl -Is https://www.google.com | head -1
