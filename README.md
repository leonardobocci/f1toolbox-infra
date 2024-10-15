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

#TODO:
Create the required airbyte secrets for state storage and connector secret management
Add ingress controller to cluster (nginx?)

After terraform provisioning:
- Connect to cluster with kubectl: \
gcloud container clusters get-credentials f1toolbox-core-cluster --zone us-central1-a --project f1toolbox-core
- Create a namespace: \
kubectl create namespace f1toolbox-core
- Update helm repos: \
helm repo update
- Create required k8s secrets: \
kubectl apply -f secrets/airbyte_instance_secrets.yaml -n f1toolbox-core \
kubectl apply -f secrets/airbyte_service_account.yaml -n f1toolbox-core
- Helm install: \
helm install f1toolbox-dagster dagster/dagster --namespace=f1toolbox-core --values charts/values/dagster.yaml \
helm install f1toolbox-airbyte airbyte/airbyte --namespace=f1toolbox-core --values charts/values/airbyte.yaml

Ingress to be added. For now connection is handled via port-forward: \
kubectl port-forward service/f1toolbox-dagster-dagster-webserver 8081:80 -n f1toolbox-core

kubectl port-forward service/f1toolbox-airbyte-airbyte-webapp-svc 8082:80 -n f1toolbox-core