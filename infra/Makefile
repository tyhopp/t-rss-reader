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
	terraform -chdir=src apply -var-file="terraform.tfvars"

delete:
	terraform -chdir=src apply -var-file="terraform.tfvars" -destroy
	rm -f ./src/login-handler.zip
	rm -f ./src/feeds-handler.zip