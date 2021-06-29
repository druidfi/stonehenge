.DEFAULT_GOAL := help

include ../utils.mk

HUGO_IMG := klakegg/hugo:latest

# If the first argument is "hugo"...
ifeq (hugo,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "hugo"
  HUGO_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(HUGO_ARGS):;@:)
endif

PHONY += up
up: site ## Launch example Hugo site
	$(call step,Start Hugo example site...)
	@docker-compose up -d
	$(call step,DONE! Check https://hugo.traefik.me ...)

PHONY += site
site: ## Create Hugo quickstart site
	$(call step,Create Hugo site to site folder)
	@docker run --rm -it -v $(shell pwd):/src $(HUGO_IMG) new site site --force
	$(call step,Download and set Ananke as theme)
	@mkdir site/themes/ananke
	@git clone https://github.com/budparr/gohugo-theme-ananke.git site/themes/ananke
	@rm -rf site/themes/ananke/.git
	@echo 'theme = "ananke"' >> site/config.toml

PHONY += down
down: ## Tear down example Hugo site
	@docker-compose down -v
	@rm -rf output site

hugo: ## Hugo CLI: Create a new content file
	@docker run --rm -it -v $(shell pwd)/site:/src -v $(shell pwd)/output:/target $(HUGO_IMG) $(HUGO_ARGS)
