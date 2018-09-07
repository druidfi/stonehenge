#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    echo "Hello osx"

else

    echo "Hello linux"

    make -v
    docker --version
    docker-compose --version
    docker network create $STONEHENGE_NETWORK_NAME
    docker-compose up -d
    docker-compose ps

fi
