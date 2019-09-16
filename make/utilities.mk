PHONY += debug
debug:
	$(call step,Debug:)
	$(call val,OS,$(OS))
	$(call val,Docker domain,$(DOCKER_DOMAIN))
	$(call val,Docker network name,$(NETWORK_NAME))
	$(call val,docker-compose installed,$(DOCKER_COMPOSE_BIN))
	$(call val,docker-compose command,$(DOCKER_COMPOSE_CMD))
	$(call val,mkcert installed,$(MKCERT_BIN))

PHONY += help
help: ## Print this help
	$(call step,Available make commands for Stonehenge:)
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

PHONY += check-scripts
check-scripts:
	@shellcheck scripts/*.sh install.sh .travis/*.sh && echo "All good"

# Colors
NO_COLOR=\033[0m
GREEN=\033[0;32m
RED=\033[0;31m
YELLOW=\033[0;33m

define step
	@. ./.env && printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef

define success
	@. ./.env && printf "\n${GREEN}${1}${NO_COLOR} ${2}\n\n"
endef

define val
	@. ./.env && printf "${YELLOW}${1}:${NO_COLOR} ${2}\n"
endef
