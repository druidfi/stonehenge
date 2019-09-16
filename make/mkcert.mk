BREW_BIN := $(shell which brew || echo no)

MKCERT_VERSION := v1.4.0
MKCERT_SOURCE := https://github.com/FiloSottile/mkcert/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-amd64
MKCERT_BIN_PATH := /usr/local/bin/mkcert

mkcert-install: ## Install mkcert
ifeq ($(OS),darwin)
	$(call step,Install mkcert with brew)
ifeq ($(BREW_BIN),no)
	$(call warn,Brew is not installed!)
else
	@brew install mkcert
endif
else ifeq ($(OS),ubuntu)
	@sudo apt install libnss3-tools
	$(call step,Download mkcert binary and make it executable)
	@wget ${MKCERT_SOURCE} -O ${MKCERT_BIN_PATH}
	@chmod +x ${MKCERT_BIN_PATH}
endif
