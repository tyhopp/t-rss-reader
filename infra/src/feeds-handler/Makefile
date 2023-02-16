targets = prepare clean

.PHONY: help $(targets)

help:
	@echo "Available targets: $(targets)"

prepare:
	npm run build
	npm run zip

clean:
	npm run clean