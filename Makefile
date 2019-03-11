PHONY :=
.DEFAULT_GOAL := help
SHELL := /bin/bash

DOCKER_COMPOSE_BIN := $(shell which docker-compose || echo no)
MKCERT_BIN := $(shell which mkcert || echo no)
MKCERT_ERROR := mkcert is not installed, see installation instructions: https://github.com/FiloSottile/mkcert#installation
OS := $(shell uname -s)

PHONY += down
down: ## Tear down Stonehenge
	$(call colorecho, "\nTear down Stonehenge\n\n- Stop and remove the containers...\n")
	@docker-compose down -v --remove-orphans
	@. ./.env && docker network remove $$NETWORK_NAME || docker network inspect $$NETWORK_NAME
	$(call colorecho, "\n- Remove resolver file...\n")
	@. ./scripts/resolver.sh && remove
	$(call colorecho, "\nDONE!\n")

PHONY += help
help: ## Print this help
	$(call colorecho, "\nAvailable make commands for Stonehenge:\n")
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

PHONY += status
status: ## Stonehenge status
	$(call colorecho, "\nStonehenge status\n")
	@docker-compose ps

PHONY += stop
stop: ## Stop Stonehenge containers
	$(call colorecho, "\nStop Stonehenge containers\n")
	@docker-compose stop
	$(call colorecho, "\nSTOPPED!\n")

PHONY += up
up: ## Launch Stonehenge
	$(call colorecho, "\nStart Stonehenge on $(OS)")
	$(resolver_create)
	$(containers_up)

PHONY += update
update: ## Update Stonehenge
	$(call colorecho, "\nUpdate Stonehenge\n\n- Pull the latest code...\n")
	@git pull
	$(containers_up)

#
# Advanced targets, not shown on help
#

PHONY += certs
certs: --certs-create-key-and-csr --certs-install-ca --certs-create-certs up

PHONY += certs-uninstall
certs-uninstall: export CAROOT = $(shell pwd)/certs
certs-uninstall:
	$(call colorecho, "\nUninstall local CA...\n")
	@mkcert -uninstall || echo "No CA found..."

PHONY += --certs-ca
--certs-install-ca: export CAROOT = $(shell pwd)/certs
--certs-install-ca:
ifeq ($(MKCERT_BIN),no)
	$(error ${MKCERT_ERROR})
else
	$(call colorecho, "\nCreate local CA...\n")
	@mkcert -install -csr certs/stonehenge.csr
endif

PHONY += --certs-create-certs
--certs-create-certs: export CAROOT = $(shell pwd)/certs
--certs-create-certs:
ifeq ($(MKCERT_BIN),no)
	$(error ${MKCERT_ERROR})
else
	$(call colorecho, "Create stonehenge.crt to ./certs folder...\n")
	@test -f certs/stonehenge.crt && echo "- already exists" || mkcert -csr certs/stonehenge.csr -cert-file certs/stonehenge.crt
endif

PHONY += --certs-create-key-and-csr
--certs-create-key-and-csr:
	$(call colorecho, "Create stonehenge.key & stonehenge.csr to ./certs folder...\n")
	@test -f certs/stonehenge.key && test -f certs/stonehenge.csr && echo "Stonehenge .key and .csr already exist" || openssl req -new \
	-newkey rsa:2048 -nodes -keyout certs/stonehenge.key \
  -out certs/stonehenge.csr \
  -subj "/O=Stonehenge/OU=Stonehenge/CN=*.${DOCKER_DOMAIN}"

#
# FUNCTIONS
#

define colorecho
	@tput -T xterm setaf 3
	@. ./.env && shopt -s xpg_echo && echo $1
	@tput -T xterm sgr0
endef

define containers_up
	$(create_network)
	$(call colorecho, "\n- Start the containers...\n")
	@docker-compose -f docker-compose.yml $$(. ./scripts/os.sh && get_compose_files) up -d --force-recreate --remove-orphans
	$(call colorecho, "\n- Adding your SSH key...\n")
	@test -f ~/.ssh/id_rsa && docker run --rm -it --volume=$$HOME/.ssh/id_rsa:/$$HOME/.ssh/id_rsa --volumes-from=stonehenge-ssh-agent --name=stonehenge-ssh-agent-add-key amazeeio/ssh-agent ssh-add ~/.ssh/id_rsa || echo "No SSH key found"
	$(call started)
endef

define create_network
	$(call colorecho, "\n- Create network $$NETWORK_NAME...\n")
	@. ./.env && docker network inspect $$NETWORK_NAME > /dev/null || docker network create $$NETWORK_NAME && echo "Network created"
endef

define resolver_create
	@test -d ~/.ssh || mkdir ~/.ssh
	$(call colorecho, "\n- Set resolver file...\n")
	@shopt -s xpg_echo && . ./scripts/resolver.sh && install
endef

define started
	$(call colorecho, "\nSUCCESS! Open http://portainer.$$DOCKER_DOMAIN...\n")
endef

define create_csr
	openssl req -new \
  -newkey rsa:2048 -nodes -keyout certs/stonehenge.key \
  -out certs/stonehenge.csr \
  -subj "/O=Stonehenge/OU=Stonehenge mkcert/CN=*.docker.sh"
endef

.PHONY: $(PHONY)

include .env

ifeq ($(DOCKER_COMPOSE_BIN),no)
$(error docker-compose is required)
endif

ifeq ($(DOCKER_DOMAIN),)
$(error DOCKER_DOMAIN not set)
endif

ifeq ($(NETWORK_NAME),)
$(error NETWORK_NAME not set)
endif
