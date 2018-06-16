.PHONY: down help up
.DEFAULT_GOAL := help

help: ## Print this help
	$(call colorecho, "\nAvailable commands for Druid Stonehenge:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: ## Launch Symfony application
	$(call colorecho, "\nCreate Symfony project to app folder")
	@composer create-project symfony/website-skeleton app
	$(call colorecho, "\nStart Symfony application")
	@docker-compose up -d

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef
