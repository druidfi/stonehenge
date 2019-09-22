#!/bin/bash

# exit when any command fails
set -e

# Colors
NO_COLOR=\033[0m
YELLOW=\033[0;33m

printf "\n\n%sInformation on this test:%s\n\n" "${YELLOW}" "${NO_COLOR}"

echo "Distribution: ${TRAVIS_DIST}"
docker --version
docker-compose --version
make debug
make ping

# Start up Stonehenge
echo "#"
echo "# Start up Stonehenge"
echo "#"
make up

echo "#"
echo "# Ping should resolve to 127.0.0.1 now"
echo "#"
make ping

# Check that we can connect to local Portainer
#curl -Is https://portainer.docker.sh | head -1
echo "#"
echo "# CURL portainer for checking access starts"
echo "#"
curl -s https://portainer.docker.sh | grep Portainer
echo "#"
echo "# CURL portainer for checking access ends"
echo "#"

# Tear down Stonehenge
echo "#"
echo "# Tear down Stonehenge"
echo "#"
make down

# Check that DNS work still
echo "#"
echo "# Check that DNS works when curling Google. Expecting HTTP/2 200"
echo "#"
curl -Is https://www.google.com | head -1
