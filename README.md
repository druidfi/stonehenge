# druidfi/stonehenge

Local development environment toolset on Docker.

## Requirements

- Docker for Mac 18.03+

## Included containers

- andyshinn/dnsmasq to route *.docker.druid.fi to 127.0.0.1
- mailhog/mailhog in [mailhog.docker.druid.fi](http://mailhog.docker.druid.fi)
- portainer/portainer in [portainer.docker.druid.fi](http://portainer.docker.druid.fi)
- traefik in [traefik.docker.druid.fi](http://traefik.docker.druid.fi)

## Setup

Setup will prompt once for your password as it creates resolver file in /etc/resolver/ folder.

### Oneliner

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/druidfi/stonehenge/master/install.sh)"
```

### Or manually with Git

```
$ git clone git@github.com:druidfi/stonehenge.git ~/druidfi-stonehenge
$ cd ~/druidfi-stonehenge
$ make up
```

## TODO

- Linux support
