.DEFAULT_GOAL := help

include ../utils.mk

app:
	$(call step,Create TYPO3 project with Composer...)
	@docker run --rm -v $(shell pwd):/app composer create-project typo3/cms-base-distribution:"^13" app --ignore-platform-reqs

PHONY += up
up: app ## Launch example TYPO3 site
	$(call step,Start TYPO3 example site...)
	@docker compose up --wait
	$(call step,Install TYPO3 with CLI...)
	@docker compose exec php-fpm vendor/bin/typo3 setup --driver=pdoMysql --no-interaction
	$(call step,DONE! Open https://typo3.docker.so ...)

PHONY += down
down: ## Tear down example TYPO3 site
	@docker compose down -v
	@chmod -R 0777 app && rm -rf app
