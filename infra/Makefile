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
	zip -r ./src/login-handler.zip ./src/login-handler
	zip -r ./src/feeds-handler.zip ./src/feeds-handler
	terraform -chdir=src apply

delete:
	terraform -chdir=src apply -destroy