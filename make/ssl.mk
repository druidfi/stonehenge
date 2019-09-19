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
	@test -f $(CERT).crt && echo "- already exists" || \
		mkcert -cert-file $(CERT).crt -key-file $(CERT).key "*.${DOCKER_DOMAIN}"
