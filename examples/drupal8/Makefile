.PHONY: app down help up
.DEFAULT_GOAL := help

DRUPAL_CONTAINER := drupal
DRUPAL_DB_URL := mysql\://drupal\:drupal@127.0.0.1\:3306/drupal
DRUPAL_PROFILE := demo_umami
DRUPAL_SITENAME := Drupal 8 example
DRUPAL_URL := https://drupal8.docker.sh
NO_COLOR=\033[0m
YELLOW=\033[0;33m

app:
	$(call step,Create Drupal 8 project to drupal folder)
	@test -d $(DRUPAL_CONTAINER) && echo "Project folder already exists" || docker run --rm --interactive --tty \
		--volume $(shell pwd):/app \
		composer create-project drupal-composer/drupal-project \
		--stability dev --no-interaction --remove-vcs --no-progress --prefer-dist --ignore-platform-reqs \
		$(DRUPAL_CONTAINER)

down: ## Tear down example Drupal 8 application
	@docker-compose down -v
	@chmod -R 0777 $(DRUPAL_CONTAINER) && rm -rf $(DRUPAL_CONTAINER)

help: ## Print this help
	$(call step,Available commands:)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: app ## Launch example Drupal 8 application
	$(call step,Start Drupal 8 example application...)
	@docker-compose up -d
	$(call step,Install site with Drush...)
	@docker-compose exec $(DRUPAL_CONTAINER) drush -y si $(DRUPAL_PROFILE) \
		--db-url=$(DRUPAL_DB_URL) \
		--site-name="$(DRUPAL_SITENAME)"
	@docker-compose exec $(DRUPAL_CONTAINER) drush -y cset system.file path.temporary /var/www/drupal/tmp
	$(call step,DONE! Check $(DRUPAL_URL) ...)

define step
	@printf "\n${YELLOW}${1}${NO_COLOR}\n\n"
endef
