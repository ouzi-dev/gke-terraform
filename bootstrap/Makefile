.EXPORT_ALL_VARIABLES:

GOOGLE_APPLICATION_CREDENTIALS ?= /Users/miguel/.gce/GKE-Cluster-01-0b2f118a38bd.json

plan:
	terraform init
	terraform plan -var-file=../vars.tfvars

apply:
	terraform apply -var-file=../vars.tfvars