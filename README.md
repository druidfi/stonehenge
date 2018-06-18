# Stonehenge

Local development environment toolset on Docker supporting multiple projects.

[![Build Status](https://travis-ci.org/druidfi/stonehenge.svg?branch=master)](https://travis-ci.org/druidfi/stonehenge)

## Requirements

- Docker for Mac 18.03+
- No other services listening port 80 (e.g. Pygmy or nginx-proxy)

## Included containers

- `andyshinn/dnsmasq` to route `*.docker.sh` to `127.0.0.1`
- `mailhog/mailhog` in [mailhog.docker.sh](http://mailhog.docker.sh) to catch emails
- `portainer/portainer` in [portainer.docker.sh](http://portainer.docker.sh) to manage your Docker
- `traefik` in [traefik.docker.sh](http://traefik.docker.sh) to handle all our reverse proxy needs

## Setup

Note: setup will prompt once for your password as it creates resolver file in `/etc/resolver` folder.

### Oneliner

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/druidfi/stonehenge/master/install.sh)"
```

### Or manually with Git

```
$ git clone git@github.com:druidfi/stonehenge.git ~/stonehenge
$ cd ~/stonehenge
$ make up
```

### Add alias

Add this line to your shell (bash, zsh, fish):

```
alias stonehenge='make -C ~/stonehenge'
```

Now you can run make targets from anywhere with the alias:

```
$ stonehenge up
```

## Example applications

- [Symfony 4](examples/symfony/README.md)

## TODO

- Examples
- Shell detection and autocreate the alias
- Linux support

## References

- [https://github.com/andyshinn/docker-dnsmasq](https://github.com/andyshinn/docker-dnsmasq)
- [https://github.com/mailhog/MailHog](https://github.com/mailhog/MailHog)
- [https://portainer.io/](https://portainer.io/)
- [https://traefik.io/](https://traefik.io/)
