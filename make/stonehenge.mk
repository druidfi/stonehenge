include $(PROJECT_DIR)/make/os.mk

DOCKER_BIN := $(shell which docker || echo no)
DOCKER_COMPOSE_BIN := $(shell which docker-compose || echo no)
NETWORK_NAME := $(PREFIX)-network
SSH_VOLUME_NAME := $(PREFIX)-ssh

# Set OS/distro specific variables
ifeq ($(OS_ID_LIKE),darwin)
	DOCKER_COMPOSE_CMD := docker-compose -f docker-compose.yml -f docker-compose-darwin.yml
else ifeq ($(OS_RELEASE_FILE_EXISTS),yes)
	DOCKER_COMPOSE_CMD := docker-compose -f docker-compose.yml -f docker-compose-linux.yml
endif

SSH_KEYS := id_ed25519 id_rsa

PHONY += addkeys
addkeys: $(SSH_KEYS)

$(SSH_KEYS):
	@$(MAKE) addkey KEY=$$HOME/.ssh/$@

PHONY += addkey
addkey: KEY := $(shell echo $$HOME)/.ssh/id_rsa
addkey: IMAGE := druidfi/ssh-agent:alpine3.12
addkey: ## Add SSH key
	$(call step,Adding SSH key "$(KEY)"...)
	@test -f $(KEY) && docker run --rm -it \
		--volume=$(KEY):$(KEY) \
		--volumes-from=${PREFIX}-ssh-agent \
		--name=${PREFIX}-ssh-agent-add-key \
		$(IMAGE) ssh-add $(KEY) || echo "No SSH key found"

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

PHONY += switch-to-1
switch-to-1: --down
	$(call step,Change to Stonehenge v1\n\n- Pull the latest code...)
	@git checkout 1.x && git pull
	@$(MAKE) up

PHONY += switch-to-2
switch-to-2: --down
	$(call step,Change to Stonehenge v2\n\n- Pull the latest code...)
	@git checkout 2.x && git pull
	@$(MAKE) up

include $(PROJECT_DIR)/make/mkcert.mk
include $(PROJECT_DIR)/make/ssl.mk
include $(PROJECT_DIR)/make/up.mk
include $(PROJECT_DIR)/make/down.mk
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
