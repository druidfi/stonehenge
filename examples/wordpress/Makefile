.DEFAULT_GOAL := help

include ../utils.mk

WP_URL := https://wordpress.docker.so

PHONY += up
up: ## Launch example Wordpress site
	$(call step,Start Wordpress example site...)
	@docker compose up --wait
	$(call step,DONE! Check https://wordpress.docker.so ...)

PHONY += down
down: ## Tear down example Wordpress site
	@docker compose down -v
