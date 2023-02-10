targets = init validate create destroy

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

init:
	terraform -chdir=src init

validate:
	terraform fmt
	terraform validate

create:
	zip ../lambda-db-handler/lambda-db-handler.zip ../lambda-db-handler/index.js
	terraform -chdir=src apply

destroy:
	terraform -chdir=src apply -destroy