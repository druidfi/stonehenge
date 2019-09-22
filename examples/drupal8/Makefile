.PHONY: app down help up
.DEFAULT_GOAL := help

include .env

DRUPAL_CONTAINER := drupal
DRUPAL_DB_URL := mysql\://drupal\:drupal@127.0.0.1\:3306/drupal
DRUPAL_PROFILE := demo_umami
DRUPAL_SITENAME := Drupal 8 example
DRUSH := docker-compose exec $(DRUPAL_CONTAINER) drush
SKELETON := drupal-composer/drupal-project
NO_COLOR=\033[0m
YELLOW=\033[0;33m

app:
	$(call step,Create $(DRUPAL_SITENAME) project folder with Composer...)
	@test -d $(DRUPAL_CONTAINER) && echo "Project folder already exists" || docker run --rm --interactive --tty \
		--volume $(shell pwd):/app composer create-project $(SKELETON) \
		--stability dev --no-interaction --remove-vcs --no-progress --prefer-dist --ignore-platform-reqs \
		$(DRUPAL_CONTAINER)

down: ## Tear down example
	@docker-compose down -v
	@chmod -R 0777 $(DRUPAL_CONTAINER) && rm -rf $(DRUPAL_CONTAINER)

help: ## Print this help
	$(call step,Available commands:)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

launch:
	$(call step,Start $(DRUPAL_SITENAME) application...)
	@docker-compose up -d

site-install:
	$(call step,Install site with Drush...)
	@$(DRUSH) -y site:install $(DRUPAL_PROFILE) --db-url=$(DRUPAL_DB_URL) --site-name="$(DRUPAL_SITENAME)"
	@$(DRUSH) -y config:set system.file path.temporary /var/www/drupal/tmp

up: app launch site-install ## Launch example
	$(call step,DONE! Check https://$(DRUPAL_URL) ...)

define step
	@printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef
