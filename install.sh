#!/bin/bash

REPO_FOLDER=~/stonehenge
REPO_URL=https://github.com/druidfi/stonehenge.git
REPO_BRANCH=master

main () {
    if [ "$(uname)" == "Darwin" ]; then
        echo "$(uname) detected..."
    else
        echo "Something else detected: $(uname)"
    fi

    if [ ! -d "$REPO_FOLDER" ] ; then
        git clone -b $REPO_BRANCH $REPO_URL $REPO_FOLDER
    fi

    cd "$REPO_FOLDER"
    git pull

    make up

    exit 0
}

main
