# Drupal 11 example

## Requirements

- druidfi/stonehenge up & running

## Setup

Install Drupal 11 application:

```console
cd examples/drupal
make up
```

Wait. It takes some time to load all the files etc.

Access the site in https://drupal.docker.so/

## CLI

Login to container:

```console
docker compose exec app bash
```

Then you can use e.g. Drush

## Teardown

You can tear down the whole example by:

```console
make down
```

This will put down the containers.
