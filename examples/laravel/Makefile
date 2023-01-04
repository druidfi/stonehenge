.DEFAULT_GOAL := help

include ../utils.mk

app:
	$(call step,Create Laravel project folder with Composer...)
	@docker run --rm -it -v $(shell pwd):/app composer create-project laravel/laravel app

PHONY += up
up: app ## Launch example Laravel application
	$(call colorecho,Start Laravel example application...)
	@docker compose up -d
	$(call step,DONE! Check https://laravel.docker.so ...)

PHONY += down
down: ## Tear down example Laravel application
	@docker compose down -v
	@chmod -R 0777 app && rm -rf app
