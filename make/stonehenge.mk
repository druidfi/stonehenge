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
	UBUNTU_VERSION := $(shell . /etc/os-release && echo "${VERSION_ID}")
else ifeq ($(OS),linux)
	DOCKER_COMPOSE_CMD := docker-compose -f docker-compose.yml -f docker-compose-linux.yml
endif

PHONY += config
config: ## Show Stonehenge container config
	$(call step,Show Stonehenge container config on $(OS)...)
	@${DOCKER_COMPOSE_CMD} config

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

PHONY += update
update: ## Update Stonehenge
	$(call step,Update Stonehenge\n\n- Pull the latest code...)
	@git pull
	@make up

#
# Include addons
#

include $(PROJECT_DIR)/make/up.mk
include $(PROJECT_DIR)/make/down.mk
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
