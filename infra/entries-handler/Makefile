targets = install prepare test clean

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

install:
	npm install

prepare:
	npm run build
	npm run zip

test:
	npm run test

clean:
	npm run clean