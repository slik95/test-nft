# Setup ————————————————————————————————————————————————————————————————————————

# Parameters
SHELL         = bash
HTTP_PORT     = 8000

# Executables
EXEC_PHP      = php
COMPOSER      = composer
GIT           = git
YARN          = yarn
NPX           = npx

# Alias
SYMFONY       = $(EXEC_PHP) bin/console

# Misc
.DEFAULT_GOAL = help
.PHONY       =  # Not needed here, but you can put your all your targets to be sure
                # there is no name conflict between your files and your targets.

## —— Symfony Makefile ———————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Composer 🧙‍♂️ ————————————————————————————————————————————————————————————
c-install: composer.lock ## Install vendors according to the current composer.lock file
	$(COMPOSER) install --no-progress --prefer-dist --optimize-autoloader

initfile: .env.dist ## Manage .env file
	cp .env.dist .env

p-install: initfile c-install db ## Install vendors according to the current composer.lock file and init db

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
db: vendor ## Reset the database
	$(EXEC_PHP) artisan db:create
	$(EXEC_PHP) artisan migrate

serve: artisan ## serve
	$(EXEC_PHP) artisan serve
