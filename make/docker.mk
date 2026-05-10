BUILDX_BUILDER := stonehenge-buildx

PHONY += buildx-create
buildx-create: ## Create Buildx Builder
	@docker buildx ls | grep -q $(BUILDX_BUILDER) || docker buildx create --name=$(BUILDX_BUILDER) --platform linux/amd64,linux/arm64
	@docker buildx use $(BUILDX_BUILDER)

PHONY += buildx-destroy
buildx-destroy: ## Destroy Buildx Builder
	@docker buildx rm $(BUILDX_BUILDER) || true

PHONY += --docker-bake
--docker-bake:
	$(call step,Baking Stonehenge Docker image...)
	@docker buildx bake -f docker-bake.hcl $(DOCKER_BAKE_FLAGS)

PHONY += docker-print
docker-print: DOCKER_BAKE_FLAGS := --print
docker-print: --docker-bake ## Print bake plan for Stonehenge Docker image

PHONY += docker-build
docker-build: DOCKER_BAKE_FLAGS := --pull --progress plain --no-cache --load --set *.platform=linux/$(CURRENT_ARCH)
docker-build: --docker-bake ## Build Stonehenge Docker image locally

PHONY += docker-release
docker-release: DOCKER_BAKE_FLAGS := --pull --no-cache --push
docker-release: buildx-create --docker-bake buildx-destroy ## Build and push Stonehenge Docker image

PHONY += docker-test
docker-test: docker-build up ## Build and start new Stonehenge Docker container
