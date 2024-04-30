include $(PROJECT_DIR)/make/os.mk

ifeq ($(shell uname -m),arm64)
	CURRENT_ARCH := arm64
else ifeq ($(shell uname -m),aarch64)
	CURRENT_ARCH := arm64
else
	CURRENT_ARCH := amd64
endif

DOCKER_BIN := $(shell command -v docker || echo no)
DOCKER_COMPOSE_CMD := docker compose
STONEHENGE_IMAGE := druidfi/stonehenge
STONEHENGE_EXISTS := $(shell docker inspect stonehenge > /dev/null 2>&1 && echo "yes" || echo "no")
CONTAINER_NAME := stonehenge

NETWORK_NAME := $(PREFIX)-network
NETWORK_EXISTS := $(shell docker network inspect ${NETWORK_NAME} > /dev/null 2>&1 && echo "yes" || echo "no")
SSH_VOLUME_NAME := $(PREFIX)-ssh
SSH_VOLUME_EXISTS := $(shell docker volume inspect ${SSH_VOLUME_NAME} > /dev/null 2>&1 && echo "yes" || echo "no")
SSH_KEYS := id_ed25519 id_rsa

UP_TARGETS := --up-pre-actions start --up-post-actions
UP_PRE_TARGETS := --up-title --up-create-network --up-create-volume
UP_POST_TARGETS := addkeys
DOWN_TARGETS := --down-title --remove --down-post-actions
POST_DOWN_ACTIONS := --down-remove-network --down-remove-volume

#
# Include plugins
#
-include $(PROJECT_DIR)/make/plugins/*.mk

#
# Launching Stonehenge
#

PHONY += up
up: $(UP_TARGETS) ## Launch Stonehenge

PHONY += --up-pre-actions
--up-pre-actions: $(UP_PRE_TARGETS)

PHONY += --up-title
--up-title:
	$(call step,Start Stonehenge)
	@echo "Startup Stonehenge on $(OS) ($(CURRENT_ARCH))"

PHONY += --up-create-network
--up-create-network:
ifeq ($(NETWORK_EXISTS),no)
	$(call step,Create network ${NETWORK_NAME}...)
	@docker network create ${NETWORK_NAME} > /dev/null 2>&1 && echo "Network created"
endif

PHONY += --up-create-volume
--up-create-volume:
ifeq ($(SSH_VOLUME_EXISTS),no)
	$(call step,Create volume ${SSH_VOLUME_NAME}...)
	@docker volume create ${SSH_VOLUME_NAME} > /dev/null 2>&1 && echo "Volume created"
endif

PHONY += start
start:
	$(call step,Start Stonehenge...)
	@${DOCKER_COMPOSE_CMD} up -d --force-recreate --remove-orphans

PHONY += --up-post-actions
--up-post-actions: $(UP_POST_TARGETS)
	$(call step,You can now access Stonehenge services with these URLs:)
ifdef HTTPS_PORT
	$(call item,- https://traefik.${DOCKER_DOMAIN}:$(HTTPS_PORT))
	$(call item,- https://mailpit.${DOCKER_DOMAIN}:$(HTTPS_PORT))
else
	$(call item,- https://traefik.${DOCKER_DOMAIN})
	$(call item,- https://mailpit.${DOCKER_DOMAIN})
endif
	$(call success,SUCCESS! Happy Developing!)

#
# Tearing down Stonehenge
#

PHONY += down
down: $(DOWN_TARGETS) ## Tear down Stonehenge

PHONY += --down-title
--down-title:
	$(call step,Tear down Stonehenge on $(OS))

PHONY += --remove
--remove:
	@${DOCKER_COMPOSE_CMD} down --volumes --remove-orphans --rmi all

PHONY += --down-remove-network
--down-remove-network:
	@docker network remove ${NETWORK_NAME} || docker network inspect ${NETWORK_NAME}

PHONY += --down-remove-volume
--down-remove-volume:
	@docker volume remove ${SSH_VOLUME_NAME} || docker volume inspect ${SSH_VOLUME_NAME}

PHONY += --down-post-actions
--down-post-actions: $(POST_DOWN_ACTIONS)
	$(call success,DONE!)

#
# SSH keys
#

PHONY += --addkeys-title
--addkeys-title:
	$(call step,Adding SSH keys...)

PHONY += addkeys
addkeys: --addkeys-title $(SSH_KEYS)

$(SSH_KEYS):
	@$(MAKE) addkey KEY=$$HOME/.ssh/$@

PHONY += addkey
addkey: KEY := $(shell echo $$HOME)/.ssh/id_rsa
addkey: ## Add SSH key
	@test -f $(KEY) && docker run --rm -it -u druid \
		--volume=$(KEY):$(KEY) \
		--volumes-from=${CONTAINER_NAME} \
		--name=${PREFIX}-ssh-agent-add-key \
		${STONEHENGE_IMAGE}:$(STONEHENGE_TAG) ssh-add $(KEY) || echo "No SSH key found"

#
# Commands
#

PHONY += keys
keys: ## List SSH keys added
	$(call step,SSH keys added)
	@docker exec ${CONTAINER_NAME} ssh-add -l

PHONY += status
status: ## Show Stonehenge status
	$(call step,Stonehenge status)
	@${DOCKER_COMPOSE_CMD} ps --all
	@make keys

PHONY += ps
ps: status ## Show Stonehenge status

PHONY += stop
stop: ## Stop Stonehenge
	$(call step,Stopping Stonehenge container...)
	@${DOCKER_COMPOSE_CMD} stop

PHONY += update
update: ## Update Stonehenge
	$(call step,Pull the latest Stonehenge code...)
	@git pull
	$(call step,Pull the latest Stonehenge image...)
	@docker pull ${STONEHENGE_IMAGE}:${STONEHENGE_TAG}
	@make up

PHONY += upgrade
upgrade: down update ## Upgrade Stonehenge (tear down the current first)

PHONY += rollback
rollback: down ## Switch back to Stonehenge 3
	$(call step,Change to Stonehenge v3...)
	@echo "Pull the latest code..."
	@git checkout 3.x && git pull
	@$(MAKE) up

PHONY += switch-to-5
switch-to-5: down ## Switch to Stonehenge 5
	$(call step,Change to Stonehenge v5...)
	@git checkout 5.x && git pull
	@$(MAKE) up

#
# Includes
#

include $(PROJECT_DIR)/make/utilities.mk
include $(PROJECT_DIR)/make/docker.mk

#
# Check requirements
#

ifeq ($(DOCKER_BIN),no)
$(error docker is required)
endif

ifeq ($(DOCKER_DOMAIN),)
$(error DOCKER_DOMAIN not set in .env)
endif

ifeq ($(PREFIX),)
$(error PREFIX not set in .env)
endif
