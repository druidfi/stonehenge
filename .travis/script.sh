#!/bin/bash

make -v
docker --version
docker-compose --version

make debug
make up
make mkcert-install
sudo make certs

curl -Is https://portainer.docker.sh | head -1

make down

curl -Is https://www.google.com | head -1
