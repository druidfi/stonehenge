PHONY += build-docker-image
build-docker-image: ## Build Stonehenge Docker image
	$(call step,Build Stonehenge Docker image...)
	@docker buildx bake -f docker-bake.hcl --pull --progress plain --no-cache --load --set *.platform=linux/arm64

PHONY += push-docker-image
push-docker-image: ## Build and push Stonehenge Docker image
	$(call step,Build Stonehenge Docker image...)
	@docker buildx bake -f docker-bake.hcl --pull --no-cache --push
