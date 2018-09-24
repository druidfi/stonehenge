#!/bin/bash

REPO_FOLDER=~/stonehenge
REPO_URL=https://github.com/druidfi/stonehenge.git
REPO_BRANCH=master

main () {
    if [ ! -d "$REPO_FOLDER" ] ; then
        git clone -b $REPO_BRANCH $REPO_URL $REPO_FOLDER
    fi

    cd "$REPO_FOLDER"
    git pull

    make up

    exit 0
}

main
