# Stonehenge

![Stonehenge logo](https://github.com/druidfi/stonehenge/raw/5.x/logos/stonehenge_logo_wide.svg)

Local development environment toolset on Docker supporting multiple projects.

![Tests](https://github.com/druidfi/stonehenge/workflows/Tests/badge.svg)

## What does it do?

Stonehenge aims to solve the basic problem for web developers: How to do development on local environment as easily as
possible.

Stonehenge provides you a shared development environment for multiple projects. It will handle the routing and local
domains for your projects as well as SSL certificates for those domains out of the box.

## Requirements for Stonehenge

- Latest macOS, Ubuntu LTS or Windows 10/11 with WSL2 - [Read more](#supported-operating-systems)
- Make
- OrbStack 1.0.0+, Docker 20.10+ or Colima 0.5.0+
- Docker Compose V2
- No other services listening port 80 or 443

## Requirements for a project

- `docker-compose.yml` file(s) - see [examples](#examples) how to use Stonehenge

## Stonehenge building blocks

- [Traefik](https://traefik.io/traefik/) in [traefik.docker.so](https://traefik.docker.so) to handle all traffic to containers
- [mkcert](https://github.com/FiloSottile/mkcert) generated wildcard SSL certificate
- [Mailpit](https://github.com/axllent/mailpit) in [mailpit.docker.so](https://mailpit.docker.so) to catch emails

## Setup

Note: in some systems setup will prompt once for your password as it will setup DNS.

If on Windows, check these [general install instructions](https://github.com/druidfi/stonehenge/blob/5.x/WSL2.md) if you don't have WSL2 yet.

### Oneliner

```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/druidfi/stonehenge/5.x/install.sh)"
```

### Or manually with Git

```console
git clone -b 5.x https://github.com/druidfi/stonehenge.git ~/stonehenge
cd ~/stonehenge
make up
```

### Using custom domain

You can also use custom domain instead of `docker.so`:

```console
make up DOCKER_DOMAIN=docker.druid.fi
```

Or alternatively change DOCKER_DOMAIN value in `.env` file.

## Stop or shutdown Stonehenge

Note: Stonehenge will be started on boot by default if not stopped before.

To stop Stonehenge:

```console
make stop
```

Or totally to stop and remove Stonehenge:

```console
make down
```

## Add alias

Add this line to your shell (bash, zsh, fish):

```console
alias stonehenge='make -C ~/stonehenge'
```

Now you can run make targets from anywhere with the alias:

```console
stonehenge up
```

## SSH keys

By default Stonehenge tries to add key from `~/.ssh/id_ed25519` and `~/.ssh/id_rsa`.

You can add additional SSH keys with:

```console
make addkey KEY=/path/to/mykey
```

## Using custom ports

You can change `https`, `http` and `smtp` ports by using ENV variables:

```console
HTTPS_PORT=8443 HTTP_PORT=8080 SMTP_PORT=25 make up
```

## Examples

- [Drupal 10](https://github.com/druidfi/stonehenge/tree/5.x/examples/drupal)
- [Ghost 5](https://github.com/druidfi/stonehenge/tree/5.x/examples/ghost)
- [Hugo](https://github.com/druidfi/stonehenge/tree/5.x/examples/hugo)
- [Laravel 9](https://github.com/druidfi/stonehenge/tree/5.x/examples/laravel)
- [Symfony 6](https://github.com/druidfi/stonehenge/tree/5.x/examples/symfony)
- [Wordpress](https://github.com/druidfi/stonehenge/tree/5.x/examples/wordpress)

## Supported operating systems

- macOS Sonoma 14 (M1/M2/M3)
- macOS Ventura 13 (Intel and M1)
- macOS Monterey 12 (Intel and M1)
- macOS Big Sur 11 (Intel and M1)
- Ubuntu 22.04 LTS
- Ubuntu 20.04 LTS
- [Windows 10/11 + WSL2](https://github.com/druidfi/stonehenge/blob/5.x/WSL2.md) (Debian or Ubuntu LTS)
- [Fedora Asahi Remix 39](https://asahilinux.org/fedora/) (M1/M2/M3)

Also tested with at some point:

- Arch Linux
- Ubuntu 18.04 LTS

## Fork and modify

To brand the toolset for your organization:

- Fork this repository
- Modify `.env` file e.g. like follows:
  - `COMPOSE_PROJECT_NAME=company`
  - `DOCKER_DOMAIN=docker.company.com`
  - `PREFIX=company`
- Point your `docker.company.com` and `*.docker.company.com` to `127.0.0.1`
- IMPORTANT! Let us know! <3

## Debug

Use following command to see what data is detected:

```console
make debug
```

## TODO

- Support for Debian and RHEL
- More examples
- Shell detection and autocreate the alias

## References

- [https://github.com/axllent/mailpit](https://github.com/axllent/mailpit)
- [https://github.com/FiloSottile/mkcert](https://github.com/FiloSottile/mkcert)
- [https://traefik.io/](https://traefik.io/)

## License

The files in this archive are released under the MIT license. You can find a copy of this license in [LICENSE](https://github.com/druidfi/stonehenge/raw/5.x/LICENSE).
