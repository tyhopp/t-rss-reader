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
	zip ./src/feeds-handler.zip ./src/feeds-handler/index.mjs
	terraform -chdir=src apply

destroy:
	terraform -chdir=src apply -destroy