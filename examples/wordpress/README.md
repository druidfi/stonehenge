# Wordpress example

## Requirements

- druidfi/stonehenge up & running

## Setup

Install Wordpress site:

```
$ cd examples/wordpress
$ make up
```

Access the site in https://wordpress.docker.so/ or in https://wordpress.traefik.me/

## Teardown

You can teardown the whole example by:

```
$ make down
```

This will put down the containers.
