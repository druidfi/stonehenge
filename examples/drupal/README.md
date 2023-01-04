# Drupal 9 example

## Requirements

- druidfi/stonehenge up & running

## Setup

Install Drupal 9 application with Composer:

```
cd examples/drupal
make up
```

Wait. It takes some time to load all the files etc.

Access the site in https://drupal9.docker.so/

## CLI

Login to container:

```
docker compose exec app bash
```

Then you can use e.g. Drush

## Teardown

You can teardown the whole example by:

```
make down
```

This will put down the containers.
