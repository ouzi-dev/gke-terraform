# gke-terraform

Get kubeconfig:

```
gcloud container clusters get-credentials CLUSTER_NAME --region=REGION
```


# TODO:

* <s>Add PodDisruptionBudget to all the kube-system items so autoscaler can move pod in kube-system</s>

* <s>Add `true` to `avoidSingleFailure` in kube-dns configmap</s>

* <s>Add permissions for estafette controllers</s>

* Add controller to avoid multiple nodes dying at the same time: https://github.com/estafette/estafette-gke-preemptible-killer

* Add pool shifter: https://github.com/estafette/estafette-gke-node-pool-shifter