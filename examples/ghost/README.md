# Ghost example

## Requirements

- druidfi/stonehenge up & running

## Setup

```console
cd examples/ghost
make up
```

Access the site in https://ghost.docker.so/

NOTE! It might take a few seconds to get Ghost to respond.

## Configure the installation

Go to https://ghost.docker.so/ghost/ and configure your Ghost instance.

## Teardown

You can tear down the whole example by:

```console
make down
```

This will put down the containers.
