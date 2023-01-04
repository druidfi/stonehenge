.DEFAULT_GOAL := help

include ../utils.mk

app:
	$(call step,Create Symfony project to app folder)
	@docker run --rm -it -v $(shell pwd):/app composer create-project symfony/symfony-demo app

PHONY += up
up: app ## Launch example Symfony application
	$(call colorecho,Start Symfony example application...)
	@docker compose up -d
	$(call step,DONE! Check https://symfony.docker.so ...)

PHONY += down
down: ## Tear down example Symfony application
	@docker compose down -v
	@chmod -R 0777 app && rm -rf app
