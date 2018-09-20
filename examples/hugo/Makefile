.PHONY: down help hugo up
.DEFAULT_GOAL := help

HUGO_IMG := klakegg/hugo:0.46

# If the first argument is "hugo"...
ifeq (hugo,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "hugo"
  HUGO_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(HUGO_ARGS):;@:)
endif

site: ## Create Hugo quickstart site
	$(call colorecho, "\nCreate Hugo site to site folder")
	@docker run --rm -it -v $(shell pwd):/src $(HUGO_IMG) new site site --force
	$(call colorecho, "\nDownload and set Ananke as theme")
	@mkdir site/themes/ananke
	@git clone https://github.com/budparr/gohugo-theme-ananke.git site/themes/ananke
	@rm -rf site/themes/ananke/.git
	@echo 'theme = "ananke"' >> site/config.toml

down: ## Tear down example Hugo site
	@docker-compose down -v
	@rm -rf output site

help: ## Print this help
	$(call colorecho, "\nAvailable commands:\n")
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

hugo: ## Hugo CLI: Create a new content file
	@docker run --rm -it -v $(shell pwd)/site:/src -v $(shell pwd)/output:/target $(HUGO_IMG) $(HUGO_ARGS)

up: site ## Launch example Hugo site
	$(call colorecho, "\nStart Hugo example site...")
	@docker-compose up -d
	$(call colorecho, "\n- DONE! Check http://hugo.docker.sh...")

define colorecho
    @tput -T xterm setaf 3
    @echo $1
    @tput -T xterm sgr0
    @echo ""
endef
