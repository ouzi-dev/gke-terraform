.EXPORT_ALL_VARIABLES:

GOOGLE_APPLICATION_CREDENTIALS ?= /Users/miguel/.gce/belitre-gketest-01.json

CLUSTER_NAME ?= coolcluster

REGION = europe-west2

init:
	terraform init -upgrade

plan: init
	terraform plan -var-file=vars.tfvars

apply: init
	terraform apply -var-file=vars.tfvars

destroy: init
	terraform destroy -var-file=vars.tfvars

apply_pdbs:
	kubectl apply -f manifests/pdbs -n kube-system

get_kubeconfig:
	gcloud container clusters get-credentials $(CLUSTER_NAME) --region=$(REGION)