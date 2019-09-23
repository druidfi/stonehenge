DOWN_TARGETS := --down-title --down --down-remove-network --down-remove-volume certs-uninstall --down-post-actions

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
--down-post-actions: RESOLV_CONF := /etc/resolv.conf
--down-post-actions: RESOLV_STUB := /run/systemd/resolve/stub-resolv.conf
--down-post-actions:
ifeq ($(OS_ID_LIKE),darwin)
	$(call step,Remove resolver file /etc/resolver/${DOCKER_DOMAIN}...)
	@sudo rm -f "/etc/resolver/${DOCKER_DOMAIN}" && echo "Resolver file removed" || echo "Already removed"
else ifeq ($(OS_ID_LIKE),arch)
	$(call step,Restore resolver file $(RESOLV_CONF)...)
	@sudo cp $(RESOLV_CONF).default $(RESOLV_CONF)
else ifeq ($(OS_ID),ubuntu)
	$(call step,Restore resolver symlink to $(RESOLV_STUB)...)
	@sudo ln -nsf $(RESOLV_STUB) $(RESOLV_CONF)
	@sudo rm /run/systemd/resolve/resolv-stonehenge.conf
else
	$(call step,No post actions defined for $(OS))
endif
	$(call success,DONE!)
