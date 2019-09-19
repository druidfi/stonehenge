MKCERT_BIN := $(shell which mkcert || echo no)
MKCERT_BIN_PATH := /usr/local/bin/mkcert
MKCERT_REPO := https://github.com/FiloSottile/mkcert
MKCERT_REQS_ARCH := nss
MKCERT_REQS_DEBIAN := libnss3-tools
MKCERT_VERSION := v1.4.0

ifeq ($(OS_ID_LIKE),darwin)
	MKCERT_SOURCE := ${MKCERT_REPO}/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-darwin-amd64
else
	MKCERT_SOURCE := ${MKCERT_REPO}/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-amd64
endif

PHONY += mkcert-install
mkcert-install: ## Install mkcert
ifeq ($(MKCERT_BIN),$(MKCERT_BIN_PATH))
	$(call step,Install mkcert)
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
	$(call step,Install mkcert requirements: $(MKCERT_REQS_DEBIAN))
	@sudo apt -y install $(MKCERT_REQS_DEBIAN)
else ifeq ($(OS_ID_LIKE),arch)
	$(call step,Install mkcert requirements: $(MKCERT_REQS_ARCH))
	@sudo pacman -S $(MKCERT_REQS_ARCH)
endif
	$(call step,Download mkcert binary and make it executable)
	@sudo wget ${MKCERT_SOURCE} -O ${MKCERT_BIN_PATH}
	@sudo chmod +x ${MKCERT_BIN_PATH}
endif
# Linux ends
endif
