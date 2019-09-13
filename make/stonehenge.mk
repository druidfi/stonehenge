.DEFAULT_GOAL := help

DOCKER_COMPOSE_BIN := $(shell which docker-compose || echo no)
OS := $(shell uname -s)
SHELL := /bin/bash

PHONY += down
down: ## Tear down Stonehenge
	$(call step,Tear down Stonehenge\n\n- Stop and remove the containers...)
	@docker-compose down -v --remove-orphans
	@docker network remove ${NETWORK_NAME} || docker network inspect ${NETWORK_NAME}
	$(call step,Remove resolver file...)
	@. ./scripts/resolver.sh && remove
	$(call step,DONE!)

PHONY += help
help: ## Print this help
	$(call step,Available make commands for Stonehenge:)
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

PHONY += check-scripts
check-scripts:
	@shellcheck scripts/*.sh install.sh .travis/*.sh && echo "All good"

PHONY += restart
restart: ## Restart Stonehenge
	$(call step,Restarting Stonehenge containers...)
	@docker-compose restart
	$(call step,Restarted!)

PHONY += status
status: ## Stonehenge status
	$(call step,Stonehenge status)
	@docker-compose ps

PHONY += stop
stop: ## Stop Stonehenge
	$(call step,Stopping Stonehenge containers...)
	@docker-compose stop
	$(call step,STOPPED!)

PHONY += up
up: ## Launch Stonehenge
	$(call step,Start Stonehenge on $(OS))
	$(call step,- Set resolver file...)
	@shopt -s xpg_echo && . ./scripts/resolver.sh && install
	$(call step,- Create network ${NETWORK_NAME}...)
	@docker network inspect ${NETWORK_NAME} > /dev/null || docker network create ${NETWORK_NAME} && echo "Network created"
	$(call step,- Start the containers...)
	@docker-compose -f docker-compose.yml $$(. ./scripts/os.sh && get_compose_files) up -d --force-recreate --remove-orphans
	$(call step,- Adding your SSH key...)
	@test -f ~/.ssh/id_rsa && docker run --rm -it --volume=$$HOME/.ssh/id_rsa:/$$HOME/.ssh/id_rsa --volumes-from=stonehenge-ssh-agent --name=stonehenge-ssh-agent-add-key amazeeio/ssh-agent ssh-add ~/.ssh/id_rsa || echo "No SSH key found"
	$(started)

PHONY += update
update: ## Update Stonehenge
	$(call step,Update Stonehenge\n\n- Pull the latest code...)
	@git pull
	@make up

#
# Include addons
#
include $(PROJECT_DIR)/make/ssl.mk

#
# FUNCTIONS
#

# Colors
NO_COLOR=\033[0m
GREEN=\033[0;32m
RED=\033[0;31m
YELLOW=\033[0;33m

define started
	$(call step,SUCCESS! Open http://portainer.$$DOCKER_DOMAIN ...)
endef

define step
	@. ./.env && printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef

ifeq ($(DOCKER_COMPOSE_BIN),no)
$(error docker-compose is required)
endif

ifeq ($(DOCKER_DOMAIN),)
$(error DOCKER_DOMAIN not set)
endif

ifeq ($(NETWORK_NAME),)
$(error NETWORK_NAME not set)
endif
