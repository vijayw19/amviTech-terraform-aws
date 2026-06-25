# AWS Terraform Modules and Service Setup

This repository provides a reusable Terraform framework for provisioning AWS infrastructure using a clean two-layer structure:

1. **Modules layer**: reusable, generic Terraform modules for AWS resources.
2. **Services layer**: team or application-specific wrappers that consume the modules with controlled inputs.

The goal of this structure is to let platform teams maintain standard Terraform modules while application or service teams consume them safely through service folders.

---

## Repository Structure

```text
.
├── modules/
│   ├── api/
│   │   └── apigw-http
│   ├── compute/
│   │   ├── EC2/
│   │   └── serverless/
│   ├── container/
│   │   ├── ecr/
│   │   ├── ecs/cluster/
│   │   ├── eks/
│   │   └── emr/
│   ├── database/
│   │   └── RDS/
│   ├── IAM/
│   │   ├── group/
│   │   ├── policy/
│   │   └── user/
│   ├── network/
│   │   ├── vpc/
│   │   ├── subnet/
│   │   ├── igw/
│   │   ├── nat_gateway/
│   │   ├── route_table/
│   │   ├── security_group/
│   │   └── network_acl/
│   └── storage/
│       └── s3/
│
└── services/
    ├── vpc/
    ├── subnets/
    ├── internet_gateway/
    ├── nat_gateway/
    ├── route_table/
    ├── security_group/
    ├── network_acl/
    ├── ec2/
    ├── lambda/
    ├── RDS/
    ├── ecs_clusters/
    └── apigw-http/
```

---

## Design Approach

This setup follows a **module + service wrapper** model.

### 1. Modules Layer

The `modules/` directory contains reusable Terraform modules. Each module should be generic and should not contain environment-specific values.

Example:

```text
modules/network/vpc/
├── resource-vpc.tf
├── variables.tf
├── output.tf
└── terraform.tf
```

The module owns the actual AWS resource definition:

```hcl
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}
```

### 2. Services Layer

The `services/` directory contains Terraform configurations that consume the reusable modules.

Each service folder usually contains:

```text
main.tf
variables.tf or variable.tf
outputs.tf or output.tf
terraform.tf
terraform.tfvars
```

Example:

```text
services/vpc/
├── main.tf
├── variable.tf
├── terraform.tf
└── terraform.tfvars
```

The service layer is where teams provide values such as region, CIDR ranges, tags, subnet IDs, instance types, and environment-specific configuration.

---

## Why This Pattern Is Useful

This pattern separates platform ownership from application ownership.

| Layer | Owner | Purpose |
|---|---|---|
| `modules/` | Platform or DevOps team | Defines standard reusable AWS resources |
| `services/` | Application or service team | Provides environment-specific values and consumes modules |

Benefits:

- Reusable Terraform modules
- Cleaner service-level configuration
- Easier onboarding for new teams
- Consistent tagging and naming
- Better separation of concerns
- Easier validation, testing, and CI/CD integration
- Safer promotion across environments such as dev, qa, stage, and prod

---

## Terraform and Provider Requirements

Each service folder includes a `terraform.tf` file similar to this:

```hcl
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}
```

### Backend Configuration

The backend block is intentionally empty:

```hcl
backend "s3" {}
```

This means backend details should be passed during `terraform init`.

Example:

```bash
terraform init \
  -backend-config="bucket=my-terraform-state-bucket" \
  -backend-config="key=dev/network/vpc/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=my-terraform-lock-table" \
  -backend-config="encrypt=true"
```

Recommended backend setup:

| Backend Item | Purpose |
|---|---|
| S3 bucket | Stores Terraform state |
| DynamoDB table | Provides state locking |
| Encryption | Protects state data at rest |
| Separate state key | Keeps each service/environment isolated |

---

## Service Folder Usage Pattern

Each service folder should be executed independently.

Example:

```bash
cd services/vpc
terraform init
terraform fmt
terraform validate
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

For production:

```bash
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

---

## Recommended Environment File Pattern

For each service, maintain one `.tfvars` file per environment:

```text
services/vpc/
├── dev.tfvars
├── qa.tfvars
├── stage.tfvars
└── prod.tfvars
```

Example `dev.tfvars`:

```hcl
aws_region = "us-east-1"

vpc_name = "dev-platform-vpc"
vpc_cidr = "10.10.0.0/16"

common_tags = {
  Environment = "dev"
  Application = "platform"
  Owner       = "devops"
  ManagedBy   = "terraform"
}
```

---

## VPC Service Example

### Folder

```text
services/vpc/
├── main.tf
├── variable.tf
├── terraform.tf
└── dev.tfvars
```

### main.tf

```hcl
module "vpc" {
  source = "../../modules/network/vpc"

  vpc_name   = var.vpc_name
  cidr_block = var.vpc_cidr
  region     = var.aws_region

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_network_address_usage_metrics = false

  instance_tenancy = "default"

  assign_generated_ipv6_cidr_block = false

  tags = var.common_tags
}
```

### dev.tfvars

```hcl
aws_region = "us-east-1"
vpc_name   = "dev-vpc"
vpc_cidr   = "10.10.0.0/16"

common_tags = {
  Environment = "dev"
  Project     = "aws-platform"
  ManagedBy   = "terraform"
}
```

### Commands

```bash
cd services/vpc
terraform init
terraform validate
terraform plan -var-file="dev.tfvars"
```

---

## Subnet Service Example

The subnet service consumes the subnet module and creates subnets inside an existing VPC.

Example `dev.tfvars`:

```hcl
aws_region = "us-east-1"
vpc_id     = "vpc-xxxxxxxx"

subnets = {
  public_subnet_1 = {
    cidr_block              = "10.10.1.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "dev-public-subnet-1"
      Tier = "public"
    }
  }

  private_subnet_1 = {
    cidr_block              = "10.10.11.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false
    tags = {
      Name = "dev-private-subnet-1"
      Tier = "private"
    }
  }
}

common_tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
```

---

## EC2 Service Example

The EC2 service supports creating multiple EC2 instances using `for_each`.

### main.tf Pattern

```hcl
module "ec2_instances" {
  source = "../../modules/compute/EC2"

  for_each = var.ec2_instances

  ami_id        = each.value.ami_id
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  key_name      = each.value.key_name

  associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)
  vpc_security_group_ids      = lookup(each.value, "vpc_security_group_ids", [])
  private_ip                  = lookup(each.value, "private_ip", null)

  root_volume_size           = lookup(each.value, "root_volume_size", 8)
  root_volume_type           = lookup(each.value, "root_volume_type", "gp3")
  root_delete_on_termination = lookup(each.value, "root_delete_on_termination", true)
  root_encrypted             = lookup(each.value, "root_encrypted", false)

  ebs_block_devices = lookup(each.value, "ebs_block_devices", [])

  user_data                   = lookup(each.value, "user_data", null)
  user_data_replace_on_change = lookup(each.value, "user_data_replace_on_change", false)

  tags = merge(var.common_tags, lookup(each.value, "tags", {}))
}
```

### dev.tfvars Example

```hcl
aws_region = "us-east-1"

common_tags = {
  Environment = "dev"
  Application = "web"
  ManagedBy   = "terraform"
}

ec2_instances = {
  web_01 = {
    ami_id                      = "ami-xxxxxxxxxxxxxxxxx"
    instance_type               = "t3.micro"
    subnet_id                   = "subnet-xxxxxxxx"
    key_name                    = "dev-keypair"
    associate_public_ip_address = false
    vpc_security_group_ids      = ["sg-xxxxxxxx"]
    root_volume_size            = 30
    root_volume_type            = "gp3"
    root_encrypted              = true

    tags = {
      Name = "dev-web-01"
      Role = "web"
    }
  }

  app_01 = {
    ami_id                 = "ami-xxxxxxxxxxxxxxxxx"
    instance_type          = "t3.small"
    subnet_id              = "subnet-yyyyyyyy"
    key_name               = "dev-keypair"
    vpc_security_group_ids = ["sg-yyyyyyyy"]
    root_volume_size       = 50
    root_volume_type       = "gp3"
    root_encrypted         = true

    tags = {
      Name = "dev-app-01"
      Role = "application"
    }
  }
}
```

---

## RDS Service Example

The RDS service also supports multiple database instances using `for_each`.

### dev.tfvars Example

```hcl
aws_region = "us-east-1"

common_tags = {
  Environment = "dev"
  Application = "orders"
  ManagedBy   = "terraform"
}

rds_instances = {
  orders_db = {
    identifier     = "dev-orders-db"
    engine         = "postgres"
    engine_version = "16.3"
    instance_class = "db.t4g.micro"

    db_name  = "ordersdb"
    username = "dbadmin"

    manage_master_user_password = true

    allocated_storage          = 20
    storage_type               = "gp3"
    enable_storage_autoscaling = true
    max_allocated_storage      = 100
    storage_encrypted          = true

    subnet_ids             = ["subnet-private-1", "subnet-private-2"]
    vpc_security_group_ids = ["sg-db"]
    publicly_accessible    = false
    multi_az               = false

    enable_backups          = true
    backup_retention_period = 7
    deletion_protection     = true
    skip_final_snapshot     = false

    enable_performance_insights = true

    tags = {
      Name = "dev-orders-db"
      Tier = "database"
    }
  }
}
```

Important: avoid storing database passwords directly in `.tfvars`. Prefer AWS Secrets Manager, `manage_master_user_password = true`, or CI/CD secret variables.

---

## Lambda Service Example

The Lambda service consumes the reusable serverless module.

Example `dev.tfvars`:

```hcl
aws_region = "us-east-1"

lambda_functions = {
  order_processor = {
    function_name = "dev-order-processor"
    runtime       = "python3.12"
    handler       = "app.lambda_handler"
    filename      = "./artifacts/order_processor.zip"
    role_arn      = "arn:aws:iam::123456789012:role/lambda-execution-role"
    timeout       = 30
    memory_size   = 256

    environment_variables = {
      ENVIRONMENT = "dev"
      LOG_LEVEL   = "INFO"
    }

    tags = {
      Name = "dev-order-processor"
    }
  }
}

common_tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
}
```

---

## API Gateway HTTP Service Example

The `apigw-http` service is intended to create HTTP API Gateway resources.

Example use cases:

- Fronting Lambda functions
- Exposing internal APIs
- Creating lightweight HTTP APIs
- Integrating application routes with backend targets

Example command:

```bash
cd services/apigw-http
terraform init
terraform validate
terraform plan -var-file="dev.tfvars"
```

---

## Network Deployment Order

For a clean AWS network foundation, deploy services in this order:

```text
1. vpc
2. subnets
3. internet_gateway
4. nat_gateway
5. route_table
6. security_group
7. network_acl
8. compute, database, container, serverless services
```

Recommended execution:

```bash
cd services/vpc
terraform apply -var-file="dev.tfvars"

cd ../subnets
terraform apply -var-file="dev.tfvars"

cd ../internet_gateway
terraform apply -var-file="dev.tfvars"

cd ../nat_gateway
terraform apply -var-file="dev.tfvars"

cd ../route_table
terraform apply -var-file="dev.tfvars"

cd ../security_group
terraform apply -var-file="dev.tfvars"
```

In a mature setup, outputs from one service should be consumed by another service using one of these methods:

1. Remote state data source
2. CI/CD pipeline variables
3. Central environment configuration
4. Terraform orchestration layer

Example remote state pattern:

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "my-terraform-state-bucket"
    key    = "dev/network/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}
```

---

## Naming Convention

Recommended naming pattern:

```text
<environment>-<application>-<resource>-<region-short>
```

Examples:

```text
dev-platform-vpc-use1
dev-platform-public-subnet-use1a
dev-orders-db-use1
dev-web-ec2-use1a
prod-platform-natgw-use1a
```

---

## Tagging Standard

Every resource should include common tags.

Recommended tags:

```hcl
common_tags = {
  Environment = "dev"
  Application = "platform"
  Owner       = "devops"
  CostCenter  = "platform-engineering"
  ManagedBy   = "terraform"
  Repository  = "aws-terraform-modules"
}
```

Why tags matter:

- Cost tracking
- Ownership
- Automation
- Security reporting
- Resource lifecycle management
- Compliance

---

## Local Validation Workflow

Run the following from each service folder.

### 1. Format Terraform

```bash
terraform fmt -recursive
```

### 2. Initialize Terraform

```bash
terraform init
```

With backend config:

```bash
terraform init \
  -backend-config="bucket=my-terraform-state-bucket" \
  -backend-config="key=dev/service-name/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="dynamodb_table=my-lock-table" \
  -backend-config="encrypt=true"
```

### 3. Validate Syntax

```bash
terraform validate
```

### 4. Create Plan

```bash
terraform plan -var-file="dev.tfvars"
```

### 5. Apply Changes

```bash
terraform apply -var-file="dev.tfvars"
```

### 6. Destroy, if needed

```bash
terraform destroy -var-file="dev.tfvars"
```

Use destroy carefully, especially for shared VPC, database, and production services.

---

## CI/CD Workflow Recommendation

A recommended pipeline should include the following stages:

```text
1. Terraform format check
2. Terraform init
3. Terraform validate
4. Terraform plan
5. Security scan
6. Manual approval for higher environments
7. Terraform apply
8. Output publishing
```

Example quality gates:

```bash
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan -out=tfplan
```

Recommended security tools:

| Tool | Purpose |
|---|---|
| Checkov | Terraform static security scanning |
| tfsec | Terraform security scanning |
| TFLint | Terraform linting and provider rule validation |
| Terratest | Automated infrastructure testing |
| Infracost | Cost estimation before apply |

---

## Current Repository Fixes Recommended Before Validation

Before running `terraform init` and `terraform validate`, fix these path and naming consistency issues.

### 1. RDS Module Source Path

Current service reference:

```hcl
source = "../../modules/database/rds"
```

Actual folder:

```text
modules/database/RDS
```

On Linux and CI/CD agents, paths are case-sensitive. Use one standard.

Recommended fix:

```hcl
source = "../../modules/database/RDS"
```

Or rename the folder to lowercase:

```text
modules/database/rds
```

### 2. Security Group Module Source Path

Current service reference:

```hcl
source = "../../modules/network/security-group"
```

Actual folder:

```text
modules/network/security_group
```

Recommended fix:

```hcl
source = "../../modules/network/security_group"
```

### 3. Standardize File Names

Some folders use `variable.tf`, others use `variables.tf`. Both work, but consistency helps teams.

Recommended standard:

```text
main.tf
variables.tf
outputs.tf
terraform.tf
terraform.tfvars
```

### 4. Avoid Hardcoding Values in Service `main.tf`

For better team control, avoid hardcoding values like this:

```hcl
enable_dns_support = true
```

Prefer:

```hcl
enable_dns_support = var.enable_dns_support
```

This lets service teams control behavior through `.tfvars`.

### 5. Avoid Open SSH Access

The security group example allows SSH from anywhere:

```hcl
cidr_blocks = ["0.0.0.0/0"]
```

For production, restrict this to corporate VPN, bastion, or SSM-based access.

Recommended:

```hcl
cidr_blocks = ["10.0.0.0/8"]
```

Or avoid SSH entirely and use AWS Systems Manager Session Manager.

---

## Best Practices

### Module Best Practices

- Keep modules reusable and environment agnostic.
- Do not hardcode region, account ID, subnet ID, or environment names inside modules.
- Use clear variable descriptions.
- Use outputs for resource IDs and ARNs.
- Use `for_each` for multiple resources.
- Use dynamic blocks where optional nested configuration is required.
- Keep sensitive values out of Terraform code.

### Service Best Practices

- Keep one service per folder.
- Use `.tfvars` files for environment-specific values.
- Use separate backend state keys per service and environment.
- Keep production protected with manual approvals.
- Use remote state or pipeline outputs to pass dependencies between services.
- Run `terraform plan` before every apply.

### Security Best Practices

- Encrypt EBS, RDS, S3, and state files.
- Use least privilege IAM roles.
- Avoid public access unless required.
- Use AWS Secrets Manager or SSM Parameter Store for secrets.
- Enable deletion protection for production databases.
- Enable VPC Flow Logs where required.
- Restrict security group ingress rules.
- Use private subnets for application and database workloads.

### State Management Best Practices

- Use S3 backend with encryption.
- Use DynamoDB for state locking.
- Separate state files by service and environment.
- Do not commit `.terraform/`, `.tfstate`, or `.tfplan` files.

Recommended `.gitignore`:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
crash.log
crash.*.log
*.tfvars
!example.tfvars
.terraform.lock.hcl
```

Note: Some teams commit `.terraform.lock.hcl` for provider consistency. Decide this based on your team standard.

---

## Example Service README Template

Each service folder should have its own README.

```markdown
# VPC Service

## Purpose

This service creates an AWS VPC using the reusable VPC module.

## Resources Created

- AWS VPC
- VPC DNS support
- VPC DNS hostnames
- Optional IPv6 configuration
- Standard tags

## Module Used

`../../modules/network/vpc`

## Input Files

- `main.tf`: Calls the reusable module
- `variables.tf`: Defines service-level inputs
- `terraform.tf`: Defines provider and backend
- `dev.tfvars`: Dev environment values
- `prod.tfvars`: Production environment values

## Commands

```bash
terraform init
terraform validate
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

## Outputs

- VPC ID
- VPC ARN
- VPC CIDR block
```

---

## Recommended Pull Request Checklist

Before merging Terraform changes:

- [ ] Code is formatted using `terraform fmt`.
- [ ] `terraform validate` passes.
- [ ] `terraform plan` was reviewed.
- [ ] No secrets are committed.
- [ ] Tags are applied.
- [ ] Backend state key is correct.
- [ ] Security groups do not expose unnecessary public access.
- [ ] Production changes have approval.
- [ ] README and examples are updated.

---

## Common Commands

```bash
# Format all Terraform files
terraform fmt -recursive

# Initialize Terraform
terraform init

# Validate Terraform configuration
terraform validate

# Plan with environment variables
terraform plan -var-file="dev.tfvars"

# Apply with environment variables
terraform apply -var-file="dev.tfvars"

# Show current state
terraform state list

# Show a specific resource
terraform state show <resource_address>

# Destroy resources
terraform destroy -var-file="dev.tfvars"
```

---

## Troubleshooting

### Error: Module directory not found

Check the module `source` path in the service `main.tf` file.

Example:

```hcl
source = "../../modules/network/security_group"
```

Make sure the folder name exactly matches the filesystem path.

### Error: Backend initialization required

Run:

```bash
terraform init -reconfigure
```

If backend values changed, pass backend config again.

### Error: No valid credential sources found

Configure AWS credentials:

```bash
aws configure
```

Or use an AWS profile:

```bash
export AWS_PROFILE=dev
terraform plan -var-file="dev.tfvars"
```

### Error: Access denied

Verify the IAM role or user has permissions for the target AWS services and the Terraform backend S3/DynamoDB resources.

### Error: Invalid provider configuration

Confirm `aws_region` is set in the `.tfvars` file.

---

## Final Recommendation

Use this repository as a reusable AWS Terraform platform foundation.

The platform team should own and version the modules under `modules/`. Application or service teams should consume those modules through `services/` folders using their own environment-specific `.tfvars` files.

This approach gives teams flexibility while keeping infrastructure standards consistent across AWS accounts and environments.
