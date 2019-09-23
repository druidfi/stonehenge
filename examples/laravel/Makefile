.PHONY: app down help up
.DEFAULT_GOAL := help

include .env

SKELETON := laravel/laravel
NO_COLOR=\033[0m
YELLOW=\033[0;33m

app:
	$(call step,Create Laravel project folder with Composer...)
	@test -d $(APP_PATH) && echo "Project folder already exists" || docker run --rm --interactive --tty \
		--volume $$HOME/.composer:/tmp \
		--volume $(shell pwd):/app \
		composer create-project $(SKELETON) --no-interaction --prefer-dist --ignore-platform-reqs $(APP_PATH)

down: ## Tear down example
	@docker-compose down -v
	@chmod -R 0777 $(APP_PATH) && rm -rf $(APP_PATH)

help: ## Print this help
	$(call step,Available commands:)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: app ## Launch example
	$(call colorecho,Start Laravel example application...)
	@docker-compose up -d
	$(call step,DONE! Check https://$(APP_HOST) ...)

define step
	@printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef
