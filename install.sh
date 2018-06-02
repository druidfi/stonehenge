#!/bin/bash

main () {
    echo "$(uname) detected...2"

    if [ "$(uname)" == "Darwin" ]; then
        echo "$(uname) detected..."
    else
        echo "$(uname) detected..."
    fi

    exit 0
}

main
