targets = init validate create delete

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

init:
	terraform -chdir=src init

validate:
	terraform fmt
	terraform validate

create:
	zip ./src/login-handler.zip ./src/login-handler/index.mjs
	zip ./src/feeds-handler.zip ./src/feeds-handler/index.mjs
	terraform -chdir=src apply

delete:
	terraform -chdir=src apply -destroy