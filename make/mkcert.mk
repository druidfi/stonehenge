MKCERT_BIN := $(shell which mkcert || echo no)
MKCERT_BIN_PATH := /usr/local/bin/mkcert
MKCERT_VERSION := v1.4.0

MKCERT_SOURCE_LINUX := https://github.com/FiloSottile/mkcert/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-amd64
MKCERT_SOURCE_MAC := https://github.com/FiloSottile/mkcert/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-darwin-amd64

PHONY += mkcert-install
mkcert-install: ## Install mkcert
	$(call step,Install mkcert)
ifeq ($(MKCERT_BIN),$(MKCERT_BIN_PATH))
	@printf "mkcert is already installed\n"
else
ifeq ($(OS),Darwin)
ifeq ($(BREW_BIN),no)
	$(call step,Download mkcert binary and make it executable)
	@curl -sL ${MKCERT_SOURCE_MAC} -o ${MKCERT_BIN_PATH}
	@chmod +x ${MKCERT_BIN_PATH}
else
	$(call step,Install mkcert with brew)
	@brew install mkcert
endif
else ifeq ($(OS),ubuntu)
	@sudo apt -y install libnss3-tools
	$(call step,Download mkcert binary and make it executable)
	@sudo wget ${MKCERT_SOURCE_LINUX} -O ${MKCERT_BIN_PATH}
	@sudo chmod +x ${MKCERT_BIN_PATH}
endif
endif
