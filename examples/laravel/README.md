# Laravel example

## Requirements

- druidfi/stonehenge up & running

## Setup

Install Laravel application with Composer:

```
$ cd examples/laravel
$ make up
```

Wait. It takes some time to load all the files etc.

Access the site in https://laravel.docker.sh/ or in https://laravel.traefik.me/

## Teardown

You can teardown the whole example by:

```
$ make down
```

This will put down the container and remove the Laravel app folder.
