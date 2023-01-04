.DEFAULT_GOAL := help

include ../utils.mk

PHONY += up
up: ## Launch example Ghost application
	$(call step,Start Ghost example application...)
	@docker compose up -d
	$(call step,DONE! Check https://ghost.docker.so ...)

PHONY += down
down: ## Tear down example Ghost application
	@docker compose down -v
