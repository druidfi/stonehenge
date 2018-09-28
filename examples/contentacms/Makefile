.PHONY: app down help up
.DEFAULT_GOAL := help

DB_URL := mysql\://drupal\:drupal@127.0.0.1\:3306/drupal

contentacms: contentacms/composer.json contentacms/composer.lock
	$(call colorecho, "\nCreate Contenta CMS project folder")
	@docker run --rm --interactive --tty --volume $(shell pwd):/app composer create-project contentacms/contenta-jsonapi-project --stability dev --no-interaction --remove-vcs --no-progress --prefer-dist --ignore-platform-reqs contentacms

down: ## Tear down example Contenta CMS application
	@docker-compose down -v
	@chmod -R 0777 contentacms && rm -rf contentacms

help: ## Print this help
	$(call colorecho, "\nAvailable commands:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: contentacms ## Launch example Contenta CMS application
	$(call colorecho, "\nStart Contenta CMS example application...")
	@docker-compose up -d
	$(call colorecho, "\nInstall site with Drush...")
	@docker-compose exec contentacms drush -y site:install contenta_jsonapi --db-url=$(DB_URL) --site-name="Contenta CMS example"
	@docker-compose exec contentacms drush en -y recipes_magazin contentajs
	$(call colorecho, "\n- DONE! Check http://contentacms.docker.sh...\n")

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef
