.EXPORT_ALL_VARIABLES:

GOOGLE_APPLICATION_CREDENTIALS ?= /Users/miguel/.gce/belitre-gketest-01.json

CLUSTER_NAME ?= coolcluster

REGION = europe-west2

init:
	terraform init -upgrade

plan: init
	terraform plan -var-file=vars.tfvars

apply: init terraform_apply push_secrets

terraform_apply: 
	terraform apply -var-file=vars.tfvars

destroy: init
	terraform destroy -var-file=vars.tfvars

get_kubeconfig:
	gcloud container clusters get-credentials $(CLUSTER_NAME) --region=$(REGION)

push_secrets:
	terraform output estafette_secret_json | aws s3 cp - s3://miguel-super-secrets/$(CLUSTER_NAME)/estafette-google-credentials.json 
	terraform output route53_secret_json | aws s3 cp - s3://miguel-super-secrets/$(CLUSTER_NAME)/route53-aws-credentials.json