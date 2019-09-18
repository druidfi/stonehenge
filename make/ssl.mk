#
# SSL related targets
#

MKCERT_BIN := $(shell which mkcert || echo no)
MKCERT_ERROR := mkcert is not installed, see installation instructions: https://github.com/FiloSottile/mkcert#installation
MKCERT_CAROOT := $(shell pwd)/certs
SH_CERTS_PATH := certs
SH_CERT_FILENAME := $(DOCKER_DOMAIN)

PHONY += certs
certs: --certs-install-ca --certs-create-certs ## Install certs

PHONY += certs-uninstall
certs-uninstall: export CAROOT = $(MKCERT_CAROOT)
certs-uninstall: ## Uninstall certs
ifeq ($(MKCERT_BIN),no)
	$(error ${MKCERT_ERROR})
else
	$(call step,Uninstall local CA...)
	@mkcert -uninstall || echo "No CA found..."
endif

PHONY += --certs-install-ca
--certs-install-ca: export CAROOT = $(MKCERT_CAROOT)
--certs-install-ca:
ifeq ($(MKCERT_BIN),no)
	$(error ${MKCERT_ERROR})
else
	$(call step,Create local CA...)
	@mkcert -install
endif

PHONY += --certs-create-certs
--certs-create-certs: export CAROOT = $(MKCERT_CAROOT)
--certs-create-certs: CERT := $(SH_CERTS_PATH)/$(SH_CERT_FILENAME)
--certs-create-certs:
ifeq ($(MKCERT_BIN),no)
	$(error ${MKCERT_ERROR})
else
	$(call step,Create $(SH_CERT_FILENAME).crt & $(SH_CERT_FILENAME).crt to ./$(SH_CERTS_PATH) folder...)
	@test -f $(CERT).crt && echo "- already exists" || \
		mkcert -cert-file $(CERT).crt -key-file $(CERT).key "*.${DOCKER_DOMAIN}"
endif

# If mkcert bin does not exist, show installation targets
ifeq ($(MKCERT_BIN),no)
include $(PROJECT_DIR)/make/mkcert.mk
endif
