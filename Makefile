SHELL := /bin/bash

install-hooks:
	command -v pre-commit 2>&1 >/dev/null || pip install pre-commit
	pre-commit install

bump-chart:
	@test -n "$(VERSION)" || (echo "VERSION environment variable is not set"; exit 1)
	sed -i 's/^version: [0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}/version: $(VERSION)/' application/Chart.yaml

build-docs: install-hooks
	# Running helm-docs-built twice to ensure that the generated docs are up-to-date
	pre-commit run helm-docs-built --all-files || true
	pre-commit run helm-docs-built --all-files
