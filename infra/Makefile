targets = init validate create delete
login_handler_path = ./src/login-handler
feeds_handler_path = ./src/feeds-handler

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

init:
	terraform -chdir=src init

validate:
	terraform fmt
	terraform validate

create:
	$(MAKE) -C $(login_handler_path) prepare
	$(MAKE) -C $(feeds_handler_path) prepare
	terraform -chdir=src apply -var-file="terraform.tfvars"

delete:
	terraform -chdir=src apply -var-file="terraform.tfvars" -destroy
	$(MAKE) -C $(login_handler_path) clean
	$(MAKE) -C $(feeds_handler_path) clean