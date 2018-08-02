# Drupal 8 example

## Requirements

- druidfi/stonehenge up & running

## Setup

Install Drupal 8 application with Composer:

```
$ cd examples/drupal8
$ make up
```

Access the site in http://drupal8.docker.sh/

## CLI

Login to container:

```
$ docker-compose exec cli bin/console
```

Then you can use e.g. Drush

## Teardown

You can teardown the whole example by:

```
$ make down
```

This will put down the container and remove the drupal folder.

## References

Drupal container from Amazee.io - https://hub.docker.com/r/amazeeio/drupal/
