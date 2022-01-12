PHONY += debug
debug:
	$(call step,Debug:)
	$(call val,Stonehenge version,$(STONEHENGE_VERSION))
	$(call val,OS,$(OS))
	$(call val,ARCH,$(CURRENT_ARCH))
	$(call val,OS_ID,$(OS_ID))
	$(call val,OS_ID_LIKE,$(OS_ID_LIKE))
	$(call val,OS_VERSION,$(OS_VERSION))
	$(call val,WSL,$(WSL))
	$(call val,Docker installed,$(DOCKER_BIN))
	$(call val,Docker Compose installed,$(DOCKER_COMPOSE_BIN))
	$(call val,Docker version,$(shell docker --version))
	$(call val,Docker domain,$(DOCKER_DOMAIN))
	$(call val,Docker network name,$(NETWORK_NAME))
#	$(call val,Docker Compose V2,$(DOCKER_COMPOSE_V2))
	$(call val,Docker Compose V1,$(shell docker-compose > /dev/null 2>&1 && echo "yes" || echo "no"))
	$(call val,docker-compose command,$(DOCKER_COMPOSE_CMD))
	$(call val,mkcert installed,$(MKCERT_BIN))
ifeq ($(OS_ID_LIKE),darwin)
	$(call val,Homebrew installed,$(BREW_BIN))
endif

PHONY += help
help: ## Print this help
	$(call step,Available make commands for Stonehenge:)
	@cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

PHONY += check-scripts
check-scripts:
	@shellcheck install.sh && echo "All good"

PHONY += ping
ping: ## Ping docker.so domain
	$(call step,Domain $(DOCKER_DOMAIN) resolves to:)
	@ping -q -c 1 -t 1 $(DOCKER_DOMAIN) | grep PING | sed -e "s/).*//" | sed -e "s/.*(//"
	$(call step,Domain foobar.$(DOCKER_DOMAIN) resolves to:)
	@ping -q -c 1 -t 1 foobar.$(DOCKER_DOMAIN) | grep PING | sed -e "s/).*//" | sed -e "s/.*(//"

PHONY += url
url: SERVICE := portainer
url:
	@echo $(SERVICE).$(DOCKER_DOMAIN)

PHONY += debug-arch
debug-arch:
	@make debug OS_RELEASE_FILE=tests/os-release.arch UNAME=Linux

PHONY += debug-manjaro
debug-manjaro:
	@make debug OS_RELEASE_FILE=tests/os-release.arch-manjaro UNAME=Linux

# Colors
NO_COLOR=\033[0m
GREEN=\033[0;32m
RED=\033[0;31m
YELLOW=\033[0;33m

define download
	@curl -s -# -L ${1} -o ${2} && test -f ${2} && echo "Downloaded ${2} from ${1}" || echo "Error: Downloading ${1} failed"
endef

define step
	@printf "\n${YELLOW}⚡ ${1}${NO_COLOR}\n\n"
endef

define item
	@echo "${1}"
endef

define success
	@printf "\n${GREEN}${1}${NO_COLOR} ${2}\n\n"
endef

define val
	@printf "${YELLOW}${1}:${NO_COLOR} ${2}\n"
endef

define warn
	@printf "\n${RED}${1}${NO_COLOR} ${2}\n\n"
endef

#
# Experimental: don't list them with help
#

#
#
#
PHONY += lineinfile
lineinfile: FILE := /tmp/foobar.conf
lineinfile: LINE := foobar=foo
lineinfile:
	$(call step,Add line to a file and how the result.\nYou can different lines with:\nmake lineinfile LINE=furbar)
	@touch $(FILE)
	$(call lineinfile,$(FILE),$(LINE))
	@cat $(FILE)

define lineinfile
	grep -qF -- "${2}" ${1} || echo "${2}" >> ${1}
endef
