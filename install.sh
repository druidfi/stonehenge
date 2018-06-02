#!/bin/bash

main () {
    echo "$(whoami):$(HOME) and $(pwd)"

    if [ "$(uname)" == "Darwin" ]; then
        echo "$(uname) detected..."
    else
        echo "Something else detected: $(uname)"
    fi

    exit 0
}

main
