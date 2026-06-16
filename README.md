# ECS ECR Production-Style Demo

This project demonstrates a real DevOps deployment flow for a simple Node.js application:

```text
GitHub
-> Feature Branch
-> Pull Request
-> Develop Branch
-> GitHub Actions
-> Docker Build
-> Push ECR
-> Deploy DEV
-> QA Testing
-> Release Branch
-> Deploy UAT
-> Business Approval
-> Main Branch
-> Deploy PROD
-> ALB
-> Users
-> CloudWatch
-> Grafana
```

## Architecture

DEV environment resources:

- VPC with public and private subnets across two Availability Zones
- Internet Gateway and NAT Gateway
- Amazon ECR repository
- ECS Fargate cluster
- ECS task definition and service
- Application Load Balancer
- Target group with `/health` check
- CloudWatch log group
- IAM task execution role
- GitHub Actions workflow to build, push, and deploy

## Branching Strategy

Use this flow:

```text
feature/ecs-ecr-dev-setup -> develop -> release/uat -> main
```

Meaning:

- `feature/*`: developer changes
- `develop`: DEV deployment
- `release/uat`: UAT deployment
- `main`: PROD deployment

## Local App Test

```powershell
cd "ECS-ECR\test\bankapp"
npm install
npm start
```

Open:

```text
http://localhost:3000
http://localhost:3000/health
```

## Docker Test

```powershell
cd "ECS-ECR\test\bankapp"
docker build -t bankapp .
docker run -p 3000:3000 bankapp
```

## First-Time DEV Deploy

Create a local tfvars file:

```powershell
cd "ECS-ECR\test\Terraform"
copy terraform.tfvars.example terraform.tfvars
```

Step 1: create only the ECR repository first:

```powershell
terraform init -upgrade
terraform fmt -recursive
terraform validate
terraform apply -target=aws_ecr_repository.app
```

Why: ECS needs a Docker image to exist before the first service deployment.

Step 2: push the first Docker image:

```powershell
aws sts get-caller-identity
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com

cd "..\bankapp"
docker build -t bankapp-dev .
docker tag bankapp-dev:latest ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/bankapp-dev:latest
docker push ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/bankapp-dev:latest
```

Replace `ACCOUNT_ID` with your AWS account ID.

Step 3: create the full infrastructure:

```powershell
cd "..\Terraform"
terraform plan
terraform apply
```

After apply:

```powershell
terraform output
```

Use `alb_dns_name` to access the app.

## GitHub Actions Secrets

Add these in GitHub:

```text
Settings -> Secrets and variables -> Actions -> New repository secret
```

Required secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

For production, prefer GitHub OIDC instead of long-lived access keys.

## Manual ECR Push After Infra Exists

```powershell
aws sts get-caller-identity
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com

cd "ECS-ECR\test\bankapp"
docker build -t bankapp-dev .
docker tag bankapp-dev:latest ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/bankapp-dev:latest
docker push ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/bankapp-dev:latest
```

Replace `ACCOUNT_ID` with your AWS account ID.

## Interview Talking Points

- ECR stores immutable container artifacts.
- ECS service keeps the desired number of tasks running.
- ALB distributes traffic and performs health checks.
- CloudWatch stores application logs.
- Terraform creates repeatable infrastructure.
- GitHub Actions automates CI/CD.
- Feature branches and PRs protect shared environments.
- UAT and PROD should have approvals before deployment.

## Cleanup

To avoid AWS costs:

```powershell
cd "ECS-ECR\test\Terraform"
terraform destroy
```
