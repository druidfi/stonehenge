RESOLV_CONF := /etc/resolv.conf
RESOLV_CONF_BAK_EXISTS := $(shell test -f ${RESOLV_CONF}.bak && echo "yes" || echo "no")

PHONY += down
down: ## Tear down Stonehenge
	$(call step,Tear down Stonehenge\n\nStop and remove the containers...)
	@${DOCKER_COMPOSE_CMD} down -v --remove-orphans
	@docker network remove ${NETWORK_NAME} || docker network inspect ${NETWORK_NAME}
	@docker volume remove ${SSH_VOLUME_NAME} || docker volume inspect ${SSH_VOLUME_NAME}
	$(call step,Remove resolver file...)
ifeq ($(OS),Darwin)
	@sudo rm -f "/etc/resolver/${DOCKER_DOMAIN}" && echo "Resolver file removed" || echo "Already removed"
else ifeq ($(RESOLV_CONF_BAK_EXISTS),yes)
	@sudo rm ${RESOLV_CONF}
	@sudo mv ${RESOLV_CONF}.bak ${RESOLV_CONF}
else
endif
	$(call success,DONE!)
