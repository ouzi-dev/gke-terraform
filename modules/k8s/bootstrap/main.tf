data "google_client_config" "current" {
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  load_config_file       = false
}

resource "kubernetes_config_map" "terraform_outputs" {
  metadata {
    name      = "terraform-outputs"
    namespace = "kube-system"
  }

  data = {
    cluster_name              = var.cluster_name
    region                    = var.region
    estafette_secret_name     = var.estafette_secret_name
    route53_creds_secret_name = var.route53_creds_secret_name
    aws_region                = var.aws_region
    hosted_zone_id            = var.ingress_hosted_zone
    hosted_zone_name          = var.ingress_hosted_zone_name
  }
}

locals {
  route53_secret_json = <<SECRET
{
    "apiVersion": "v1",
    "kind": "Secret",
    "type": "Opaque",
    "metadata": {
        "name": "${var.route53_creds_secret_name}"
    },
    "data": {
        "AWS_ACCESS_KEY_ID": "${base64encode(var.route53_secret_key_id)}",
        "AWS_SECRET_ACCESS_KEY": "${base64encode(var.route53_secret_access_key)}"
    }
}
SECRET


  estaffete_secret_json = <<SECRET
{
    "apiVersion": "v1",
    "kind": "Secret",
    "type": "Opaque",
    "metadata": {
        "name": "${var.estafette_secret_name}"
    },
    "data": {
        "google-service-account.json": "${var.estafette_google_service_account_b64}"
    }
}
SECRET

}

