# druidfi/stonehenge

Local development environment toolset on Docker.

## Included containers

- andyshinn/dnsmasq to route *.docker.druid.fi to 127.0.0.1
- mailhog/mailhog in [mailhog.docker.druid.fi](mailhog.docker.druid.fi)
- portainer/portainer in [portainer.docker.druid.fi](portainer.docker.druid.fi)
- traefik in [traefik.docker.druid.fi](traefik.docker.druid.fi)

## Setup

### Oneliner

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/druidfi/stonehenge/master/install.sh)"
```

### Manually with Git

```
$ git clone git@github.com:druidfi/stonehenge.git ~/druid-stonehenge
$ cd ~/druid-stonehenge
$ make up
```
