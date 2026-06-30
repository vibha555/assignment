<<<<<<< HEAD
# EKS Terraform Jenkins Project

Production-style DevOps project to create an Amazon EKS cluster using Terraform modules, S3 remote backend with DynamoDB locking, and Jenkins pipeline stages for `fmt`, `init`, `validate`, `plan`, `apply`, `destroy`, and Kubernetes deployment.

## Structure

```text
terraform/
  backend/
    dev.hcl
    prod.hcl
  envs/
    dev/main.tf
    prod/main.tf
  modules/
    vpc/
    iam/
    eks/
    ecr/
    alb/
    jenkins/
kubernetes/
  namespace.yaml
  deployment.yaml
  service.yaml
Jenkinsfile
```

## Backend prerequisites

Create these manually before running Terraform:

- S3 bucket for Terraform state
- DynamoDB table with partition key `LockID` as String

Update:

```text
terraform/backend/dev.hcl
terraform/backend/prod.hcl
```

## Local commands

```bash
cd terraform/envs/dev
terraform init -backend-config=../../backend/dev.hcl
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Configure kubectl:

```bash
aws eks update-kubeconfig --region ap-south-1 --name hospital-dev-eks
kubectl apply -f ../../../kubernetes
kubectl get svc -n hospital
```

## Jenkins parameters

- `ENVIRONMENT`: dev or prod
- `ACTION`: plan, apply, destroy, deploy-app

Required Jenkins tools on agent:

- terraform
- aws cli
- kubectl
- git

Required Jenkins AWS credentials:

- `aws-access-key-id`
- `aws-secret-access-key`
=======
# hospital-devops-project-
terraform usecase
>>>>>>> 7cb90dfa7782a13362b108f91afdd76964c16d09
