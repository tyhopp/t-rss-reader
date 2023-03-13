targets = install test init validate create delete
login_handler_path = ./login-handler
feeds_handler_path = ./feeds-handler
entries_handler_path = ./entries-handler
last_access_handler_path = ./last-access-handler

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

install:
	$(MAKE) -C $(login_handler_path) install
	$(MAKE) -C $(feeds_handler_path) install
	$(MAKE) -C $(entries_handler_path) install
	$(MAKE) -C $(last_access_handler_path) install

test:
	$(MAKE) -C $(login_handler_path) test
	$(MAKE) -C $(feeds_handler_path) test
	$(MAKE) -C $(entries_handler_path) test
	$(MAKE) -C $(last_access_handler_path) test

init:
	$(MAKE) install
	terraform init

validate:
	terraform fmt
	terraform validate

create:
	$(MAKE) -C $(login_handler_path) prepare
	$(MAKE) -C $(feeds_handler_path) prepare
	$(MAKE) -C $(entries_handler_path) prepare
	$(MAKE) -C $(last_access_handler_path) prepare
	terraform apply -var-file="terraform.tfvars"

delete:
	terraform apply -var-file="terraform.tfvars" -destroy
	$(MAKE) -C $(login_handler_path) clean
	$(MAKE) -C $(feeds_handler_path) clean
	$(MAKE) -C $(entries_handler_path) clean
	$(MAKE) -C $(last_access_handler_path) clean