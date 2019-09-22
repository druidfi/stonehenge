.PHONY: down help up
.DEFAULT_GOAL := help

SF_URL := https://symfony.docker.sh
NO_COLOR=\033[0m
YELLOW=\033[0;33m

app:
	$(call step,Create Symfony project to app folder)
	@docker run --rm --interactive --tty --volume $(shell pwd):/app composer create-project symfony/website-skeleton app

down: ## Tear down example Symfony application
	@docker-compose down -v
	@chmod -R 0777 app && rm -rf app

help: ## Print this help
	$(call step,Available commands:)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: app ## Launch example Symfony application
	$(call colorecho,Start Symfony example application...)
	@docker-compose up -d
	$(call step,DONE! Check $(SF_URL) ...)

define step
	@printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef
