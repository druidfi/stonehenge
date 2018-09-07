#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    echo "Hello osx. Docker cannot be used with osx in Travis. Sorry."

else

    echo "Hello $TRAVIS_OS_NAME"

    make -v
    docker --version
    docker-compose --version
    docker network create $STONEHENGE_NETWORK_NAME
    docker-compose up -d
    docker-compose ps

fi
