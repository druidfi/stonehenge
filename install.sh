#!/bin/bash

main () {
    echo "$(whoami) and $(pwd)"

    if [ "$(uname)" == "Darwin" ]; then
        echo "$(uname) detected..."
    else
        echo "$(uname) detected..."
    fi

    exit 0
}

main
