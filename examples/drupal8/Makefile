.PHONY: app down help up
.DEFAULT_GOAL := help

DB_URL := mysql\://drupal\:drupal@127.0.0.1\:3306/drupal

app:
	$(call colorecho, "\nCreate Drupal 8 project to drupal folder")
	@docker run --rm --interactive --tty --volume $(shell pwd):/app composer create-project drupal-composer/drupal-project --no-interaction --stability dev --ignore-platform-reqs drupal

down: ## Tear down example Drupal 8 application
	@docker-compose down -v
	@chmod -R 0777 drupal && rm -rf drupal

help: ## Print this help
	$(call colorecho, "\nAvailable commands:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: app ## Launch example Drupal 8 application
	$(call colorecho, "\nStart Drupal 8 example application...")
	@docker-compose up -d
	$(call colorecho, "\nInstall site with Drush...")
	@docker-compose exec drupal drush -y site:install demo_umami --db-url=$(DB_URL) --site-name="Drupal 8 example"
	$(call colorecho, "\n- DONE! Check http://drupal8.docker.sh...\n")

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef
