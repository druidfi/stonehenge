.PHONY: down help up
.DEFAULT_GOAL := help

GHOST_URL := https://ghost.docker.sh
NO_COLOR=\033[0m
YELLOW=\033[0;33m

down: ## Tear down example Ghost application
	@docker-compose down -v

help: ## Print this help
	$(call step,Available commands:)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: ## Launch example Ghost application
	$(call step,Start Ghost example application...)
	@docker-compose up -d
	$(call step,DONE! Check $(GHOST_URL) ...)

define step
	@printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef
