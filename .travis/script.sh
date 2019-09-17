#!/bin/bash

make -v
docker --version
docker-compose --version

make debug
make up
make mkcert-install
make certs

curl -Is https://portainer.docker.sh | head -1
