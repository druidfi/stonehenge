MKCERT_BIN := $(shell which mkcert || echo no)
MKCERT_BIN_PATH := /usr/local/bin/mkcert
MKCERT_REPO := https://github.com/FiloSottile/mkcert
MKCERT_REQS_ARCH := nss
MKCERT_REQS_DEBIAN := libnss3-tools
MKCERT_VERSION := v1.4.3

UP_PRE_TARGETS += mkcert-install certs

ifeq ($(OS_ID_LIKE),darwin)
	MKCERT_SOURCE := ${MKCERT_REPO}/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-darwin-amd64
else
	MKCERT_SOURCE := ${MKCERT_REPO}/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-$(CURRENT_ARCH)
endif

PHONY += mkcert-install
mkcert-install: ## Install mkcert
ifeq ($(MKCERT_BIN),$(MKCERT_BIN_PATH))
	$(call step,Install mkcert)
	$(call item,mkcert is already installed 👍)
else
# macOS starts
ifeq ($(OS_ID_LIKE),darwin)
ifeq ($(BREW_BIN),no)
	$(call step,Download mkcert binary and make it executable)
	@curl -# -L ${MKCERT_SOURCE} -o ${MKCERT_BIN_PATH}
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
	@sudo pacman --noconfirm -S $(MKCERT_REQS_ARCH)
endif
	$(call step,Download mkcert binary and make it executable)
	@sudo curl -# -L ${MKCERT_SOURCE} -o ${MKCERT_BIN_PATH}
	@sudo chmod +x ${MKCERT_BIN_PATH}
endif
# Linux ends
endif

#
# SSL related targets
#

MKCERT_ERROR := mkcert is not installed, see installation instructions: https://github.com/FiloSottile/mkcert#installation
MKCERT_CAROOT := $(shell pwd)/certs
SH_CERTS_PATH := certs
SH_CERT_FILENAME := $(DOCKER_DOMAIN)

PHONY += certs
certs: --certs-install-ca --certs-create-certs ## Install certs

PHONY += certs-uninstall
certs-uninstall: export CAROOT = $(MKCERT_CAROOT)
certs-uninstall: ## Uninstall certs
	$(call step,Uninstall local CA...)
	@mkcert -uninstall || echo "No CA found..."
	@rm -rf $(SH_CERTS_PATH)/*.crt $(SH_CERTS_PATH)/*.key $(SH_CERTS_PATH)/*.pem

PHONY += --certs-install-ca
--certs-install-ca: export CAROOT = $(MKCERT_CAROOT)
--certs-install-ca:
	$(call step,Create local CA...)
	@mkcert -install

PHONY += --certs-create-certs
--certs-create-certs: export CAROOT = $(MKCERT_CAROOT)
--certs-create-certs: CERT := $(SH_CERTS_PATH)/$(SH_CERT_FILENAME)
--certs-create-certs:
	$(call step,Create $(SH_CERT_FILENAME).crt & $(SH_CERT_FILENAME).crt to ./$(SH_CERTS_PATH) folder...)
	@test -f $(CERT).crt && echo "Certificates already exists 👍" || \
		mkcert -cert-file $(CERT).crt -key-file $(CERT).key "*.${DOCKER_DOMAIN}"
