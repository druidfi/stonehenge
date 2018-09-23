#!/bin/bash

#
# Remember to lint this script with: https://www.shellcheck.net/
#

shopt -s xpg_echo

REPO_FOLDER=~/stonehenge2
REPO_URL=https://github.com/druidfi/stonehenge.git
REPO_BRANCH=master

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

    echo -e "${LCYAN}"
    ascii
    echo -e "${NC}"

    if [ ! -d "$REPO_FOLDER" ] ; then
        echo -e "${GREEN}Clone the Stonehenge repository to ${REPO_FOLDER}${NC}"
        git clone -b $REPO_BRANCH $REPO_URL $REPO_FOLDER
    fi

    cd "$REPO_FOLDER" || exit 1

    echo -e "${GREEN}Update the code...${NC}"
    git pull

    echo -e "${GREEN}Start up the Stonehenge...${NC}"
    make up

    exit 0
}

main
