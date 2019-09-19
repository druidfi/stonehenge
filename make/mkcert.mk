MKCERT_BIN := $(shell which mkcert || echo no)
MKCERT_BIN_PATH := /usr/local/bin/mkcert
MKCERT_VERSION := v1.4.0

ifeq ($(OS_ID_LIKE),darwin)
	MKCERT_SOURCE := https://github.com/FiloSottile/mkcert/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-darwin-amd64
else
	MKCERT_SOURCE := https://github.com/FiloSottile/mkcert/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-amd64
endif

PHONY += mkcert-install
mkcert-install: ## Install mkcert
	$(call step,Install mkcert)
ifeq ($(MKCERT_BIN),$(MKCERT_BIN_PATH))
	@printf "mkcert is already installed\n"
else
# macOS starts
ifeq ($(OS_ID_LIKE),darwin)
ifeq ($(BREW_BIN),no)
	$(call step,Download mkcert binary and make it executable)
	@curl -sL ${MKCERT_SOURCE} -o ${MKCERT_BIN_PATH}
	@chmod +x ${MKCERT_BIN_PATH}
else
	$(call step,Install mkcert with brew)
	@brew install mkcert
endif
# macOS ends
else
# Linux
ifeq ($(OS_ID_LIKE),debian)
	$(call step,Install mkcert requirements: libnss3-tools)
	@sudo apt -y install libnss3-tools
else ifeq ($(OS_ID_LIKE),arch)
	$(call step,Install mkcert requirements: nss)
	@sudo pacman -Sy nss
endif
	$(call step,Download mkcert binary and make it executable)
	@sudo wget ${MKCERT_SOURCE} -O ${MKCERT_BIN_PATH}
	@sudo chmod +x ${MKCERT_BIN_PATH}
endif
# Linux ends
endif
