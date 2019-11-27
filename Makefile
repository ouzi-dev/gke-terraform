.PHONY: init
init:
	@terraform init

.PHONY: validate
validate:
	@terraform validate 

.PHONY: fmt
fmt: 
	@terraform fmt --recursive .

.PHONY: format
format: fmt

.PHONY: semantic-release
semantic-release:
	npm ci
	npx semantic-release

.PHONY: semantic-release-dry-run
semantic-release-dry-run:
	npm ci
	npx semantic-release -d