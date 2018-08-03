.PHONY: down help up
.DEFAULT_GOAL := help

down: ## Tear down example Wordpress site
	@docker-compose down -v

help: ## Print this help
	$(call colorecho, "\nAvailable commands:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

up: app ## Launch example Wordpress site
	$(call colorecho, "\nStart Wordpress example site...")
	@docker-compose up -d
	$(call colorecho, "\n- DONE! Check http://wordpress.docker.sh...\n")

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
endef
