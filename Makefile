.PHONY: validate fmt format

validate:
	@terraform validate 

fmt: 
	@terraform fmt --recursive .

format: fmt