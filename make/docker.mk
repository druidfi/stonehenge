PHONY += docker-build-image
docker-build-image: ## Build Stonehenge Docker image locally
	$(call step,Build Stonehenge Docker image locally...)
	@docker buildx bake -f docker-bake.hcl --pull --progress plain --no-cache --load --set *.platform=linux/arm64

PHONY += docker-push-image
docker-push-image: ## Build and push Stonehenge Docker image
	$(call step,Build and push Stonehenge Docker image...)
	@docker buildx bake -f docker-bake.hcl --pull --no-cache --push
