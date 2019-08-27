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
  }
}

locals {
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

