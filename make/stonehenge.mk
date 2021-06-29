include $(PROJECT_DIR)/make/os.mk

DOCKER_BIN := $(shell which docker || echo no)
DOCKER_COMPOSE_BIN := $(shell which docker-compose || echo no)
DOCKER_COMPOSE_CMD := docker-compose
NETWORK_NAME := $(PREFIX)-network
NETWORK_EXISTS := $(shell docker network inspect ${NETWORK_NAME} > /dev/null 2>&1 && echo "yes" || echo "no")
SSH_VOLUME_NAME := $(PREFIX)-ssh
SSH_VOLUME_EXISTS := $(shell docker volume inspect ${SSH_VOLUME_NAME} > /dev/null 2>&1 && echo "yes" || echo "no")
SSH_KEYS := id_ed25519 id_rsa

UP_TARGETS := --up-pre-actions --up --up-post-actions
UP_PRE_TARGETS := --up-title --up-create-network --up-create-volume
UP_POST_TARGETS := addkeys
DOWN_TARGETS := --down-title --down --down-post-actions
POST_DOWN_ACTIONS := --down-remove-network --down-remove-volume certs-uninstall

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
	$(call step,Start Stonehenge on $(OS))

PHONY += --up-create-network
--up-create-network:
ifeq ($(NETWORK_EXISTS),no)
	$(call step,Create network ${NETWORK_NAME}...)
	@docker network create ${NETWORK_NAME} && echo "- Network created"
endif

PHONY += --up-create-volume
--up-create-volume:
ifeq ($(SSH_VOLUME_EXISTS),no)
	$(call step,Create volume ${SSH_VOLUME_NAME}...)
	@docker volume create ${SSH_VOLUME_NAME} && echo "SSH volume created"
endif

PHONY += --up
--up:
	$(call step,Start the containers...)
	@${DOCKER_COMPOSE_CMD} up -d --force-recreate --remove-orphans

PHONY += --up-post-actions
--up-post-actions: $(UP_POST_TARGETS)
	$(call step,You can now access Stonehenge services with these URLs:)
	$(call item,https://traefik.${DOCKER_DOMAIN} OR https://dashboard.traefik.me)
	$(call item,https://portainer.${DOCKER_DOMAIN} OR https://portainer.traefik.me)
	$(call item,https://mailhog.${DOCKER_DOMAIN} OR https://mailhog.traefik.me)
	$(call success,SUCCESS! Happy Developing!)

#
# Tearing down Stonehenge
#

PHONY += down
down: $(DOWN_TARGETS) ## Tear down Stonehenge

PHONY += --down-title
--down-title:
	$(call step,Tear down Stonehenge on $(OS))

PHONY += --down
--down:
	@${DOCKER_COMPOSE_CMD} down -v --remove-orphans

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

PHONY += addkeys
addkeys: $(SSH_KEYS)

$(SSH_KEYS):
	@$(MAKE) addkey KEY=$$HOME/.ssh/$@

PHONY += addkey
addkey: KEY := $(shell echo $$HOME)/.ssh/id_rsa
addkey: IMAGE := druidfi/ssh-agent:$(SSH_IMAGE_VERSION)
addkey: ## Add SSH key
	$(call step,Adding SSH key "$(KEY)"...)
	@test -f $(KEY) && docker run --rm -it \
		--volume=$(KEY):$(KEY) \
		--volumes-from=${PREFIX}-ssh-agent \
		--name=${PREFIX}-ssh-agent-add-key \
		$(IMAGE) ssh-add $(KEY) || echo "No SSH key found"

#
# Commands
#

PHONY += config
config: ## Show Stonehenge container config
	$(call step,Show Stonehenge container config on $(OS)...)
	@${DOCKER_COMPOSE_CMD} config

PHONY += keys
keys: ## List SSH keys added
	$(call step,SSH keys added)
	@${DOCKER_COMPOSE_CMD} exec ssh-agent ssh-add -l

PHONY += restart
restart: ## Restart Stonehenge
	$(call step,Restarting Stonehenge containers...)
	@${DOCKER_COMPOSE_CMD} restart
	$(call success,Restarted!)

PHONY += status
status: ## Show Stonehenge status
	$(call step,Stonehenge status)
	@${DOCKER_COMPOSE_CMD} ps
	@make keys

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

PHONY += upgrade
upgrade: down update ## Upgrade Stonehenge (tear down the current first)

PHONY += switch-to-2
switch-to-2: --down ## Switch to Stonehenge 2
	$(call step,Change to Stonehenge v2\n\n- Pull the latest code...)
	@git checkout 2.x && git pull
	@$(MAKE) up

#
# Includes
#

include $(PROJECT_DIR)/make/utilities.mk

#
# Check requirements
#

ifeq ($(DOCKER_BIN),no)
$(error docker is required)
endif

ifeq ($(DOCKER_COMPOSE_BIN),no)
$(error docker-compose is required)
endif

ifeq ($(DOCKER_DOMAIN),)
$(error DOCKER_DOMAIN not set in .env)
endif

ifeq ($(PREFIX),)
$(error PREFIX not set in .env)
endif
