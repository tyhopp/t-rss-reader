targets = init validate create delete
login_handler_path = ./login-handler
feeds_handler_path = ./feeds-handler

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

init:
	$(MAKE) -C $(login_handler_path) install
	$(MAKE) -C $(feeds_handler_path) install
	terraform init

validate:
	terraform fmt
	terraform validate

create:
	$(MAKE) -C $(login_handler_path) prepare
	$(MAKE) -C $(feeds_handler_path) prepare
	terraform apply -var-file="terraform.tfvars"

delete:
	terraform apply -var-file="terraform.tfvars" -destroy
	$(MAKE) -C $(login_handler_path) clean
	$(MAKE) -C $(feeds_handler_path) clean