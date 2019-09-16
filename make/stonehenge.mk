.DEFAULT_GOAL := help
SHELL := /bin/bash

DOCKER_COMPOSE_BIN := $(shell which docker-compose || echo no)
NETWORK_NAME := $(PREFIX)-network
OS := $(shell . ./scripts/functions.sh && get_distribution)
SSH_VOLUME_NAME := $(PREFIX)-ssh

ifeq ($(OS),darwin)
	DOCKER_COMPOSE_CMD := docker-compose -f docker-compose.yml -f docker-compose-darwin.yml
else ifeq ($(OS),ubuntu)
	DOCKER_COMPOSE_CMD := docker-compose -f docker-compose.yml -f docker-compose-linux.yml
else ifeq ($(OS),linux)
	DOCKER_COMPOSE_CMD := docker-compose -f docker-compose.yml -f docker-compose-linux.yml
endif

PHONY += config
config: ## Show Stonehenge container config
	$(call step,Show Stonehenge container config on $(OS)...)
	@${DOCKER_COMPOSE_CMD} config

PHONY += down
down: ## Tear down Stonehenge
	$(call step,Tear down Stonehenge\n\nStop and remove the containers...)
	@${DOCKER_COMPOSE_CMD} down -v --remove-orphans
	@docker network remove ${NETWORK_NAME} || docker network inspect ${NETWORK_NAME}
	@docker volume remove ${SSH_VOLUME_NAME} || docker volume inspect ${SSH_VOLUME_NAME}
	$(call step,Remove resolver file...)
ifeq ($(OS),darwin)
	@sudo rm -f "/etc/resolver/${DOCKER_DOMAIN}" && echo "Resolver file removed" || echo "Already removed"
else ifeq ($(OS),Linux)
	@. ./scripts/functions.sh && remove_resolver
endif
	$(call success,DONE!)

PHONY += restart
restart: ## Restart Stonehenge
	$(call step,Restarting Stonehenge containers...)
	@${DOCKER_COMPOSE_CMD} restart
	$(call success,Restarted!)

PHONY += status
status: ## Stonehenge status
	$(call step,Stonehenge status)
	@${DOCKER_COMPOSE_CMD} ps

PHONY += stop
stop: ## Stop Stonehenge
	$(call step,Stopping Stonehenge containers...)
	@${DOCKER_COMPOSE_CMD} stop
	$(call success,Stopped!)

PHONY += up
up: ## Launch Stonehenge
	$(call step,Start Stonehenge on $(OS))
	$(call step,Create resolver file...)
	@. ./scripts/functions.sh && install_resolver
	$(call step,Create network ${NETWORK_NAME}...)
	@docker network inspect ${NETWORK_NAME} > /dev/null || docker network create ${NETWORK_NAME} && echo "Network created"
	$(call step,Create volume ${SSH_VOLUME_NAME}...)
	@docker volume inspect ${SSH_VOLUME_NAME} > /dev/null || docker volume create ${SSH_VOLUME_NAME} && echo "SSH volume created"
	$(call step,Start the containers...)
	@${DOCKER_COMPOSE_CMD} up -d --force-recreate --remove-orphans
	$(call step,Adding your SSH key...)
	@test -f ~/.ssh/id_rsa && docker run --rm -it --volume=$$HOME/.ssh/id_rsa:/$$HOME/.ssh/id_rsa --volumes-from=${PREFIX}-ssh-agent --name=${PREFIX}-ssh-agent-add-key amazeeio/ssh-agent ssh-add ~/.ssh/id_rsa || echo "No SSH key found"
	$(call success,SUCCESS! Open http://portainer.${DOCKER_DOMAIN} ...)

PHONY += update
update: ## Update Stonehenge
	$(call step,Update Stonehenge\n\n- Pull the latest code...)
	@git pull
	@make up

#
# Include addons
#

include $(PROJECT_DIR)/make/utilities.mk
include $(PROJECT_DIR)/make/ssl.mk

#
# Check requirements
#

ifeq ($(DOCKER_COMPOSE_BIN),no)
$(error docker-compose is required)
endif

ifeq ($(DOCKER_DOMAIN),)
$(error DOCKER_DOMAIN not set in .env)
endif

ifeq ($(PREFIX),)
$(error PREFIX not set in .env)
endif
