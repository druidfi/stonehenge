PHONY += build-docker-image
build-docker-image: ## Build Stonehenge Traefik Docker image
	$(call step,Build Stonehenge Traefik Docker image...)
	@docker buildx bake -f docker-bake.hcl --pull --progress plain --no-cache --load --set *.platform=linux/arm64
