#
# SSL related targets
#

MKCERT_BIN := $(shell which mkcert || echo no)
MKCERT_ERROR := mkcert is not installed, see installation instructions: https://github.com/FiloSottile/mkcert#installation

PHONY += certs
certs: --certs-create-key-and-csr --certs-install-ca --certs-create-certs up ## Install certs

PHONY += certs-uninstall
certs-uninstall: export CAROOT = $(shell pwd)/certs
certs-uninstall:
	$(call colorecho, "\nUninstall local CA...\n")
	@mkcert -uninstall || echo "No CA found..."

PHONY += --certs-ca
--certs-install-ca: export CAROOT = $(shell pwd)/certs
--certs-install-ca:
ifeq ($(MKCERT_BIN),no)
	$(error ${MKCERT_ERROR})
else
	$(call colorecho, "\nCreate local CA...\n")
	@mkcert -install -csr certs/stonehenge.csr
endif

PHONY += --certs-create-certs
--certs-create-certs: export CAROOT = $(shell pwd)/certs
--certs-create-certs:
ifeq ($(MKCERT_BIN),no)
	$(error ${MKCERT_ERROR})
else
	$(call colorecho, "Create stonehenge.crt to ./certs folder...\n")
	@test -f certs/stonehenge.crt && echo "- already exists" || mkcert -csr certs/stonehenge.csr -cert-file certs/stonehenge.crt
endif

PHONY += --certs-create-key-and-csr
--certs-create-key-and-csr:
	$(call colorecho, "Create stonehenge.key & stonehenge.csr to ./certs folder...\n")
	@test -f certs/stonehenge.key && test -f certs/stonehenge.csr && echo "Stonehenge .key and .csr already exist" || openssl req -new \
	-newkey rsa:2048 -nodes -keyout certs/stonehenge.key \
  -out certs/stonehenge.csr \
  -subj "/O=Stonehenge/OU=Stonehenge/CN=*.${DOCKER_DOMAIN}"

define create_csr
	openssl req -new \
  -newkey rsa:2048 -nodes -keyout certs/stonehenge.key \
  -out certs/stonehenge.csr \
  -subj "/O=Stonehenge/OU=Stonehenge mkcert/CN=*.docker.sh"
endef
