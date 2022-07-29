#!/usr/bin/env sh

if [ $# -lt 2 ]
then
    printf "Missing options!\n\n"
    printf "docker exec stonehenge remove-service name domain\n\n"
    printf "Example:\n"
    printf "docker exec stonehenge remove-service foobar mydomain.com\n"
    exit 0
fi

NAME=$1
DOMAIN=$2
HOST="$NAME.$DOMAIN"
FILENAME="/configuration/$HOST.yml"
CERT="/ssl/$DOMAIN"

test -f $FILENAME && rm $FILENAME && echo "- $FILENAME removed 👍" || echo "- $FILENAME does not exist"
test -f $CERT.crt && rm $CERT.crt && echo "- $CERT.crt removed 👍" || echo "- $CERT.crt does not exist"
test -f $CERT.key && rm $CERT.key && echo "- $CERT.key removed 👍" || echo "- $CERT.key does not exist"
