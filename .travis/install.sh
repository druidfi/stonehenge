#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then

    echo "Hello osx"

else

    echo "Hello $TRAVIS_OS_NAME"

    # Install latest Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get -y install docker-ce

    # Install docker-compose
    sudo rm /usr/local/bin/docker-compose
    curl -L $DOCKER_COMPOSE_REPO/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > docker-compose
    chmod +x docker-compose
    sudo mv docker-compose /usr/local/bin

fi
