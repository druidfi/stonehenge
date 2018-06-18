#!/bin/bash

REPO_FOLDER=~/stonehenge
REPO_URL=git@github.com:druidfi/stonehenge.git

main () {
    if [ "$(uname)" == "Darwin" ]; then
        echo "$(uname) detected..."
    else
        echo "Something else detected: $(uname)"
    fi

    if [ ! -d "$REPO_FOLDER" ] ; then
        git clone $REPO_URL $REPO_FOLDER
    fi

    cd "$REPO_FOLDER"
    git pull

    make up

    exit 0
}

main
