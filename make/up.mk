UP_TARGETS := --up-title mkcert-install certs --up-pre-actions --up-create-network --up-create-volume --up --ssh --up-post-actions

define RESOLVER_BODY_DARWIN
# Generated by druidfi/stonehenge
nameserver 127.0.0.1
port 6053
endef

define RESOLVER_BODY_LINUX
# Generated by druidfi/stonehenge
nameserver 127.0.0.48
endef

PHONY += up
up: $(UP_TARGETS) ## Launch Stonehenge

PHONY += --up-title
--up-title:
	$(call step,\nStart Stonehenge on $(OS))

export RESOLVER_BODY_DARWIN
PHONY += --up-pre-actions
--up-pre-actions:
ifeq ($(OS_ID_LIKE),darwin)
	$(call step,Create resolver file /etc/resolver/${DOCKER_DOMAIN}...)
	@test -d /etc/resolver || sudo mkdir -p /etc/resolver
	@sudo sh -c "printf '$$RESOLVER_BODY_DARWIN' > /etc/resolver/${DOCKER_DOMAIN}" && echo "Resolver file created"
endif

PHONY += --up-create-network
--up-create-network:
	$(call step,Create network ${NETWORK_NAME}...)
	@docker network inspect ${NETWORK_NAME} > /dev/null || \
		docker network create ${NETWORK_NAME} && echo "Network created"

PHONY += --up-create-volume
--up-create-volume:
	$(call step,Create volume ${SSH_VOLUME_NAME}...)
	@docker volume inspect ${SSH_VOLUME_NAME} > /dev/null || \
		docker volume create ${SSH_VOLUME_NAME} && echo "SSH volume created"

PHONY += --up
--up:
	$(call step,Start the containers on...)
	@${DOCKER_COMPOSE_CMD} up -d --force-recreate --remove-orphans

PHONY += --ssh
--ssh:
	$(call step,Adding your SSH key on...)
	@test -f ~/.ssh/id_rsa && docker run --rm -it \
		--volume=$$HOME/.ssh/id_rsa:/$$HOME/.ssh/id_rsa \
		--volumes-from=${PREFIX}-ssh-agent \
		--name=${PREFIX}-ssh-agent-add-key \
		amazeeio/ssh-agent ssh-add ~/.ssh/id_rsa || echo "No SSH key found"

export RESOLVER_BODY_LINUX
PHONY += --up-post-actions
--up-post-actions:
#
# Resolver for Ubuntu is made in post actions so dnsmasq is available in 127.0.0.48:53
#
ifeq ($(OS_ID),ubuntu)
	$(call step,Create resolver file /run/systemd/resolve/resolv-stonehenge.conf on $(OS)...)
	@sudo sh -c "printf '$$RESOLVER_BODY_LINUX' > /run/systemd/resolve/resolv-stonehenge.conf"
	@sudo ln -nsf /run/systemd/resolve/resolv-stonehenge.conf /etc/resolv.conf
endif
	$(call success,SUCCESS! Open https://portainer.${DOCKER_DOMAIN} ...)
