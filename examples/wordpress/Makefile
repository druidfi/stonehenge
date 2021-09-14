.DEFAULT_GOAL := help

include ../utils.mk

WP_URL := https://wordpress.docker.so

PHONY += up
up: ## Launch example Wordpress site
	$(call step,Start Wordpress example site...)
	@docker-compose up -d
	@echo "Wait for 5 seconds so database gets ready..." && sleep 5
	$(call step,DONE! Check https://wordpress.docker.so ...)

PHONY += down
down: ## Tear down example Wordpress site
	@docker-compose down -v
