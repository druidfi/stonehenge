# Contenta CMS example

## Requirements

- druidfi/stonehenge up & running

## Setup

Install Contenta CMS application with Composer:

```
$ cd examples/contentacms
$ make up
```

Wait. It takes some time to load all the files etc.

Access the site in http://contentacms.docker.sh/

## CLI

Login to container:

```
$ docker-compose exec drupal bash
```

Then you can use e.g. Drush

## Teardown

You can teardown the whole example by:

```
$ make down
```

This will put down the container and remove the drupal folder.

## References

- Contenta CMS - https://www.contentacms.org
- Drupal container from Amazee.io - https://hub.docker.com/r/amazeeio/drupal/
