.PHONY: down help up
.DEFAULT_GOAL := help

WP_URL := https://wordpress.docker.sh
NO_COLOR=\033[0m
YELLOW=\033[0;33m

down: ## Tear down example Wordpress site
	@docker-compose down -v

help: ## Print this help
	$(call step,Available commands:)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: ## Launch example Wordpress site
	$(call step,Start Wordpress example site...)
	@docker-compose up -d
	$(call step,DONE! Check $(WP_URL) ...)

define step
	@printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef
