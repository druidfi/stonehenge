#!/bin/bash

BRANCH=${TRAVIS_PULL_REQUEST_BRANCH:-$TRAVIS_BRANCH}

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    echo "Hello osx. Docker cannot be used with osx in Travis. Sorry."

else

    echo "Hello $TRAVIS_OS_NAME"

    make -v
    docker --version
    docker-compose --version

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/druidfi/stonehenge/${BRANCH}/install.sh)"

    if curl -s http://portainer.docker.sh | grep "portainer.io"
    then
        echo "Success: portainer.docker.sh is responding."
    else
        echo "Error: portainer.docker.sh is NOT responding."
        exit 1
    fi

fi
