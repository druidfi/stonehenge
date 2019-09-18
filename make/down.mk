DOWN_TARGETS := --down-title --down --down-remove-network --down-remove-volume --down-post-actions

RESOLV_CONF := /etc/resolv.conf
RESOLV_CONF_BAK_EXISTS := $(shell test -f ${RESOLV_CONF}.default && echo "yes" || echo "no")
RESOLV_STUB := /run/systemd/resolve/stub-resolv.conf

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
--down-post-actions:
ifeq ($(OS),Darwin)
	$(call step,Remove resolver file on $(OS)...)
	@sudo rm -f "/etc/resolver/${DOCKER_DOMAIN}" && echo "Resolver file removed" || echo "Already removed"
else ifeq ($(OS),ubuntu)
	$(call step,Restore resolver file symlink to $(RESOLV_STUB) on $(OS) $(UBUNTU_VERSION)...)
	sudo ln -nsf $(RESOLV_STUB) /etc/resolv.conf
else
endif
	$(call success,DONE!)
