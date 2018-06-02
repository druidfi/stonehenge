#!/bin/bash

main () {
    if [ "$(uname)" == "Darwin" ]; then
        echo "$(uname) detected..."
    else
        exit 1
    fi

    exit 0
}
