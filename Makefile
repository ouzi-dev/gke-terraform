.EXPORT_ALL_VARIABLES:

GOOGLE_APPLICATION_CREDENTIALS ?= /Users/miguel/.gce/belitre-gketest-01.json

init:
	terraform init -upgrade

plan: init
	terraform plan -var-file=vars.tfvars

apply: init
	terraform apply -var-file=vars.tfvars

destroy: init
	terraform destroy -var-file=vars.tfvars
