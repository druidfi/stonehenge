.DEFAULT_GOAL := help

include ../utils.mk

DRUPAL_SITENAME := Drupal example
EXECUTE := docker compose exec app

PHONY += up
up: ## Launch example
	$(call step,Start $(DRUPAL_SITENAME) application...)
	@docker compose up --wait
	$(call step,Install $(DRUPAL_SITENAME) with Drush...)
	@$(EXECUTE) sudo chmod -R 0777 /app/public/sites/default/files
	@$(EXECUTE) drush -y site:install demo_umami --account-name="admin" --site-name="$(DRUPAL_SITENAME)"
	$(call step,DONE! Open https://drupal.docker.so ... Also check for admin credentials ^^)

PHONY += down
down: ## Tear down example
	@docker compose down -v
