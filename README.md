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
