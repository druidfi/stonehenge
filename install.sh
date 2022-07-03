#!/bin/bash

#
# Remember to lint this script with: https://www.shellcheck.net/
#

shopt -s xpg_echo

REPO_FOLDER=~/stonehenge
REPO_URL=https://github.com/druidfi/stonehenge.git
REPO_BRANCH=4.x

GREEN='\033[0;32m'
NC='\033[0m' # No Color
LCYAN='\033[01;36m'

ascii () {
cat << "EOF"


Installing

███████╗████████╗ ██████╗ ███╗   ██╗███████╗██╗  ██╗███████╗███╗   ██╗ ██████╗ ███████╗
██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║██╔════╝██║  ██║██╔════╝████╗  ██║██╔════╝ ██╔════╝
███████╗   ██║   ██║   ██║██╔██╗ ██║█████╗  ███████║█████╗  ██╔██╗ ██║██║  ███╗█████╗
╚════██║   ██║   ██║   ██║██║╚██╗██║██╔══╝  ██╔══██║██╔══╝  ██║╚██╗██║██║   ██║██╔══╝
███████║   ██║   ╚██████╔╝██║ ╚████║███████╗██║  ██║███████╗██║ ╚████║╚██████╔╝███████╗
╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

Multi-project local development environment & toolset on Docker


EOF
}

main () {

    clear

    echo "${LCYAN}"
    ascii
    echo "${NC}"

    if [ ! -d "$REPO_FOLDER" ] ; then
        echo "${GREEN}Clone the Stonehenge repository to ${REPO_FOLDER}${NC}"
        git clone -b $REPO_BRANCH $REPO_URL $REPO_FOLDER
    fi

    cd "$REPO_FOLDER" || exit 1

    echo "${GREEN}Update the code...${NC}"
    git pull

    echo "${GREEN}Start up the Stonehenge...${NC}"
    make up

    exit 0
}

main
