# f1toolbox-infra

Depoly GCP infrastructure using Terraform cloud:

1. K8s Cluster (dagster, airbyte, metabase)
2. GCS buckets
3. Api layer: #TODO

Get started:
- A. Terraform cloud account
- B. GCP new project
- C. GCP service account for terraform (download json key) with owner permissions
- D. Terraform cloud integration with git repo (under /infra directory)
- E. Terraform sensitive variable GOOGLE_CREDENTIALS with contents of json key
- F. Terraform environment variable project set to GCP project name
- G. Enable GCP required APIs (Service Usage API, Cloud Resource Manager API)

After terraform provisioning:
- Connect to cluster with kubectl: \
gcloud container clusters get-credentials f1toolbox-core-cluster --zone us-central1-c --project f1toolbox-core
- Create a namespace: \
kubectl create namespace f1toolbox-core
- Update helm repos: \
helm repo update
- Create required k8s secrets: \
kubectl apply -f secrets/airbyte_instance_secrets.yaml -n f1toolbox-core \
kubectl apply -f secrets/airbyte_service_account.yaml -n f1toolbox-core

Authentication to GCP APIs via workflow identity federation: \
A k8s service account will impersonate a GCP IAM-handled service account to gain access to protected resources like cloud storage via IAM role assignment. \
https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#kubernetes-sa-to-iam \
Can be achieved by running kubectl commands: \
```kubectl create serviceaccount dagster-ksa --namespace=f1toolbox-core```
```gcloud iam service-accounts add-iam-policy-binding gke-workflow-identity@f1toolbox-core.iam.gserviceaccount.com --role roles/iam.workloadIdentityUser --member "serviceAccount:f1toolbox-core.svc.id.goog[f1toolbox-core/dagster-ksa]"```
```kubectl annotate serviceaccount dagster-ksa --namespace f1toolbox-core iam.gke.io/gcp-service-account=gke-workflow-identity@f1toolbox-core.iam.gserviceaccount.com```

Helm install: \
helm install f1toolbox-dagster dagster/dagster --namespace=f1toolbox-core --values charts/dagster.yaml \
helm install f1toolbox-airbyte airbyte/airbyte --namespace=f1toolbox-core --values charts/airbyte.yaml

Test service availability via port-forward: \
kubectl port-forward service/f1toolbox-dagster-dagster-webserver 8081:80 -n f1toolbox-core
kubectl port-forward service/f1toolbox-airbyte-airbyte-webapp-svc 8082:80 -n f1toolbox-core

Helm install new versions:
helm upgrade f1toolbox-dagster dagster/dagster --namespace=f1toolbox-core --values charts/dagster.yaml
helm upgrade f1toolbox-airbyte airbyte/airbyte --namespace=f1toolbox-core --values charts/airbyte.yaml

To add a specific dagster user deployment tag (eg. when latest does not pull a fresh one):
helm upgrade f1toolbox-dagster dagster/dagster --namespace=f1toolbox-core --values charts/dagster.yaml --set dagster-user-deployments.deployments[0].image.tag=<DOCKERHUB_TAG>

Ingress setup:
https://github.com/GoogleCloudPlatform/community/blob/master/archived/nginx-ingress-gke/index.md

1. Create nginx ingress controller (after disabling load balancer addon on gke):
```
#terraform for gke cluster
addons_config {
    http_load_balancing {
      disabled = true
    }
  }

#terminal
helm upgrade --install ingress-nginx ingress-nginx   --repo https://kubernetes.github.io/ingress-nginx   --namespace ingress-nginx --create-namespace
```
2. Add ingress resource with multiple rules:
```
kubectl apply -f gke_ingress/resource.yaml -n f1toolbox-core
```