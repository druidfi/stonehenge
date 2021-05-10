.DEFAULT_GOAL := help

include ../utils.mk

DRUPAL_SITENAME := Drupal 9 example
EXECUTE := docker-compose exec app

PHONY += up
up: ## Launch example
	$(call step,Start $(DRUPAL_SITENAME) application...)
	@docker-compose up -d
	$(call step,Install $(DRUPAL_SITENAME) with Drush...)
	@$(EXECUTE) sudo chmod -R 0777 /app/public/sites/default/files
	@echo "Wait for 5 seconds so database gets ready..." && sleep 5
	@$(EXECUTE) drush -y site:install demo_umami --account-name="admin" --site-name="$(DRUPAL_SITENAME)"
	$(call step,DONE! Open https://drupal9.docker.sh OR https://drupal9.traefik.me ... Also check for admin credentials ^^)

PHONY += down
down: ## Tear down example
	@docker-compose down -v
