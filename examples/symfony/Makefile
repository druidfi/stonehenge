.PHONY: down help up
.DEFAULT_GOAL := help

app:
	$(call colorecho, "\nCreate Symfony project to app folder")
	@docker run --rm --interactive --tty --volume $(shell pwd):/app composer create-project symfony/website-skeleton app

down: ## Tear down example Symfony application
	@docker-compose down -v

help: ## Print this help
	$(call colorecho, "\nAvailable commands:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: app ## Launch example Symfony application
	$(call colorecho, "\nStart Symfony example application...")
	@docker-compose up -d
	$(call colorecho, "\n- DONE! Check http://symfony.docker.sh...\n")

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef
