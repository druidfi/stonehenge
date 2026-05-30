MKCERT_BIN := $(shell command -v mkcert || echo no)
MKCERT_BIN_PATH := /usr/local/bin/mkcert
MKCERT_REPO := https://github.com/FiloSottile/mkcert
MKCERT_REQS_ARCH := nss
MKCERT_REQS_DEBIAN := libnss3-tools
MKCERT_VERSION := v1.4.4

UP_PRE_TARGETS += mkcert-install certs
POST_DOWN_ACTIONS += certs-uninstall

ifeq ($(OS_ID_LIKE),darwin)
	MKCERT_SOURCE := ${MKCERT_REPO}/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-darwin-$(CURRENT_ARCH)
else
	MKCERT_SOURCE := ${MKCERT_REPO}/releases/download/${MKCERT_VERSION}/mkcert-${MKCERT_VERSION}-linux-$(CURRENT_ARCH)
endif

PHONY += mkcert-install
mkcert-install: ## Install mkcert
ifeq ($(MKCERT_BIN),no)
# macOS starts
ifeq ($(OS_ID_LIKE),darwin)
ifeq ($(BREW_BIN),no)
	$(call step,Download mkcert binary and make it executable)
	@curl -# -L ${MKCERT_SOURCE} -o ${MKCERT_BIN_PATH}
	@chmod +x ${MKCERT_BIN_PATH}
else
	$(call step,Install mkcert with brew $(MKCERT_BIN))
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
else
	$(call step,Install mkcert)
	$(call item,mkcert is already installed 👍)
endif

#
# SSL related targets
#

MKCERT_ERROR := mkcert is not installed, see installation instructions: https://github.com/FiloSottile/mkcert#installation
MKCERT_CAROOT := $(shell pwd)/certs
SH_CERTS_PATH := certs

PHONY += certs
certs: --certs-install-ca --certs-dockerso --certs-traefikme ## Install certs

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

PHONY += --certs-dockerso
--certs-dockerso: export CAROOT = $(MKCERT_CAROOT)
--certs-dockerso: SH_CERT_FILENAME := $(DOCKER_DOMAIN)
--certs-dockerso: CERT := $(SH_CERTS_PATH)/$(SH_CERT_FILENAME)
--certs-dockerso:
	$(call step,Create $(SH_CERT_FILENAME).crt & $(SH_CERT_FILENAME).crt to ./$(SH_CERTS_PATH) folder...)
	@test -f $(CERT).crt && echo "Certificates already exist 👍" || \
		mkcert -cert-file $(CERT).crt -key-file $(CERT).key "*.${DOCKER_DOMAIN}"

PHONY += --certs-traefikme
--certs-traefikme: export CAROOT = $(MKCERT_CAROOT)
--certs-traefikme: SH_CERT_FILENAME := traefik.me
--certs-traefikme: CERT := $(SH_CERTS_PATH)/$(SH_CERT_FILENAME)
--certs-traefikme:
	$(call step,Create $(SH_CERT_FILENAME).crt & $(SH_CERT_FILENAME).crt to ./$(SH_CERTS_PATH) folder...)
	@test -f $(CERT).crt && echo "Certificates already exist 👍" || \
		mkcert -cert-file $(CERT).crt -key-file $(CERT).key "*.traefik.me"

PHONY += create-custom-certs
create-custom-certs: export CAROOT = $(MKCERT_CAROOT)
create-custom-certs: CERT := $(SH_CERTS_PATH)/$(DOMAIN)
create-custom-certs:
	$(call step,Create $(DOMAIN).crt & $(DOMAIN).crt to ./$(DOMAIN) folder...)
	@test -f $(CERT).crt && echo "Certificates already exist 👍" || \
		mkcert -cert-file $(CERT).crt -key-file $(CERT).key "*.$(DOMAIN)"

PHONY += setup-domain-certs
setup-domain-certs: TLS_DYNAMIC_FILE := traefik/dynamic/$(DOMAIN).ssl.yml
setup-domain-certs: $(if $(DOMAIN),create-custom-certs,$(error DOMAIN is required, e.g. make setup-domain-certs DOMAIN=myproject.test))
	$(call step,Create TLS dynamic file ./$(TLS_DYNAMIC_FILE)...)
	@if [ -f $(TLS_DYNAMIC_FILE) ]; then \
		grep -qF "certFile: /ssl/$(DOMAIN).crt" $(TLS_DYNAMIC_FILE) && \
		grep -qF "keyFile: /ssl/$(DOMAIN).key" $(TLS_DYNAMIC_FILE) && \
		echo "TLS config already exists 👍" || \
		{ echo "Error: $(TLS_DYNAMIC_FILE) exists but does not match the expected Traefik TLS config. Delete it and rerun setup-domain-certs." >&2; exit 1; }; \
	else \
		printf "tls:\n  certificates:\n    - certFile: /ssl/$(DOMAIN).crt\n      keyFile: /ssl/$(DOMAIN).key\n" > $(TLS_DYNAMIC_FILE); \
	fi

PHONY += teardown-domain-certs
teardown-domain-certs: CERT := $(SH_CERTS_PATH)/$(DOMAIN)
teardown-domain-certs: TLS_DYNAMIC_FILE := traefik/dynamic/$(DOMAIN).ssl.yml
teardown-domain-certs: $(if $(DOMAIN),,$(error DOMAIN is required, e.g. make teardown-domain-certs DOMAIN=myproject.test))
	$(call step,Remove $(DOMAIN).crt & $(DOMAIN).key from ./$(SH_CERTS_PATH) folder...)
	@test -f $(CERT).crt && rm -f $(CERT).crt && echo "Certificate removed: $(CERT).crt 👍" || echo "Certificate already absent, skipped: $(CERT).crt"
	@test -f $(CERT).key && rm -f $(CERT).key && echo "Key removed: $(CERT).key 👍" || echo "Key already absent, skipped: $(CERT).key"
	$(call step,Remove TLS dynamic file ./$(TLS_DYNAMIC_FILE)...)
	@test -f $(TLS_DYNAMIC_FILE) && rm -f $(TLS_DYNAMIC_FILE) && echo "TLS config removed: $(TLS_DYNAMIC_FILE) 👍" || echo "TLS config already absent, skipped: $(TLS_DYNAMIC_FILE)"
