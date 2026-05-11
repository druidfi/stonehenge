# TYPO3 13 example

## Requirements

- druidfi/stonehenge up & running

## Setup

```console
cd examples/typo3
make up
```

Access the site at https://typo3.docker.so

Backend login at https://typo3.docker.so/typo3 with `admin` / `Admin1234!`

## CLI

Login to the PHP container:

```console
docker compose exec php-fpm sh
```

Then you can use the TYPO3 CLI:

```console
vendor/bin/typo3 list
```

## Teardown

```console
make down
```
