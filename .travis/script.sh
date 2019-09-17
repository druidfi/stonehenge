#!/bin/bash

make -v
docker --version
docker-compose --version

make debug
make up
make mkcert-install
