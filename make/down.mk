RESOLV_CONF_BAK_EXISTS := $(shell test -f resolv.conf.bak && echo "yes" || echo "no")

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
	@sudo rm /etc/resolv.conf
	@sudo mv /etc/resolv.conf.bak /etc/resolv.conf
else
endif
	$(call success,DONE!)
