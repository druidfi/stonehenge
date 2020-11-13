# Stonehenge

![Stonehenge logo](logos/stonehenge_logo_wide.svg)

Local development environment toolset on Docker supporting multiple projects.

![Tests](https://github.com/druidfi/stonehenge/workflows/Tests/badge.svg)

## What does it do?

Stonehenge aims to solve the basic problem for web developers: How to do development on local environment as easily as
possible.

Stonehenge provides you a shared development environment for multiple projects. It will handle the routing and local
domains for your projects as well as SSL certificates for those domains out of the box.

## Requirements for Stonehenge

- Latest macOS or Ubuntu LTS - [Read more](#supported-operating-systems)
- Make
- Docker 18.06.0+
- Docker Compose
- No other services listening port 80 or 443

## Requirements for a project

- `docker-compose.yml` file(s) - see [examples](#examples) how to use Stonehenge

## Stonehenge building blocks

- `andyshinn/dnsmasq` to route `*.docker.sh` to localhost
- `mailhog/mailhog` in [mailhog.docker.sh](https://mailhog.docker.sh) to catch emails
- `portainer/portainer` in [portainer.docker.sh](https://portainer.docker.sh) to manage your Docker (username: `admin`, password: `admin`)
- `traefik` in [traefik.docker.sh](https://traefik.docker.sh) to handle all traffic to containers
- [mkcert](https://github.com/FiloSottile/mkcert) generated wildcard SSL certificate

## Setup

Note: in some systems setup will prompt once for your password as it will setup DNS.

### Oneliner

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/druidfi/stonehenge/2.x/install.sh)"
```

### Or manually with Git

```
$ git clone -b 2.x https://github.com/druidfi/stonehenge.git ~/stonehenge
$ cd ~/stonehenge
$ make up
```

### Using custom domain

You can also use custom domain instead of `docker.sh`:

```
$ make up DOCKER_DOMAIN=docker.druid.fi
```

Or alternatively change DOCKER_DOMAIN value in `.env` file.

## Stop or shutdown Stonehenge

Note: Stonehenge will be started on boot by default if not stopped before.

To stop Stonehenge:

```
$ make stop
```

Or totally to stop and remove Stonehenge:

```
$ make down
```

## Add alias

Add this line to your shell (bash, zsh, fish):

```
alias stonehenge='make -C ~/stonehenge'
```

Now you can run make targets from anywhere with the alias:

```
$ stonehenge up
```

## SSH keys

By default Stonehenge tries to add key from `~/.ssh/id_rsa`.

You can add additional SSH keys with:

```
$ make addkey KEY=mykey
```

## Examples

- [Contenta CMS](examples/contentacms)
- [Drupal 8](examples/drupal8)
- [Ghost](examples/ghost)
- [Hugo](examples/hugo)
- [Laravel](examples/laravel)
- [Symfony 4](examples/symfony)
- [Wordpress](examples/wordpress)

## Supported operating systems

- macOS Catalina 10.15
- Ubuntu 18.04 LTS

Also tested with at some point:

- Arch Linux
- macOS High Sierra 10.13
- macOS Mojave 10.14
- Manjaro 17.1 (Arch Linux)
- Manjaro 18.1 (Arch Linux)
- Ubuntu 16.04 LTS
- Ubuntu 17.10

## Fork and modify

To brand the toolset for your organization:

- Fork this repository
- Modify `.env` file e.g. like follows:
  - `COMPOSE_PROJECT_NAME=company`
  - `DOCKER_DOMAIN=docker.company.com`
  - `LOGO_URL=https://your-cool-logo.png`
  - `PREFIX=company`
- Point your `docker.company.com` and `*.docker.company.com` to `127.0.0.1`
- IMPORTANT! Let us know! <3

## Debug

Use following command to see what data is detected:

```
$ make debug
```

## TODO

- Support for Debian and RHEL
- Support for Windows (if feasible)
- More examples
- Shell detection and autocreate the alias

## References

- [https://github.com/andyshinn/docker-dnsmasq](https://github.com/andyshinn/docker-dnsmasq)
- [https://github.com/mailhog/MailHog](https://github.com/mailhog/MailHog)
- [https://portainer.io/](https://portainer.io/)
- [https://traefik.io/](https://traefik.io/)

## License

The files in this archive are released under the MIT license. You can find a copy of this license in [LICENSE](LICENSE).
