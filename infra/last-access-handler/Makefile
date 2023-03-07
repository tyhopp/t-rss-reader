targets = install prepare clean

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

install:
	npm install

prepare:
	npm run build
	npm run zip

clean:
	npm run clean