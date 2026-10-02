# terraform-database-reliability
# https://docs.google.com/document/d/1JysMjVbOEZIfuLQwGGYXXs8PKtf4EbcexnOyGwOkDvw/edit?tab=t.0  for read docuemnt

# Terraform + Database Reliability

A DevOps assessment demonstrating infrastructure-as-code with Terraform and practical database reliability operations using PostgreSQL, Docker Compose, shell scripting, and GitHub Actions.

The project includes:

* Terraform infrastructure for dev and prod environments
* Reusable Terraform modules
* AWS VPC with public and private subnets
* ECS/Fargate infrastructure
* Private PostgreSQL RDS configuration
* Docker Compose PostgreSQL database for local development
* SQL database migrations
* Seed data
* PostgreSQL backup and restore scripts
* Database query optimization
* Terraform formatting and validation through GitHub Actions

---

## 1. Project Architecture

The intended AWS architecture is:

```text
                    Internet
                       |
                       v
                  Application
                       |
                       v
                  ECS / Fargate
                       |
                       v
                 Private Subnets
                       |
                       v
                PostgreSQL RDS
```

The database is not publicly accessible.

The intended network architecture contains:

* One VPC
* Two public subnets
* Two private subnets
* Internet Gateway
* NAT Gateway
* Public route table
* Private route table
* ECS resources in private subnets
* RDS PostgreSQL in private subnets

---

## 2. Repository Structure

```text
terraform-database-reliability/
│
├── infra/
│   ├── modules/
│   │   ├── network/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── ecs/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   └── rds/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   └── envs/
│       ├── dev/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   ├── dev.tfvars
│       │   └── backend.tf
│       │
│       └── prod/
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           ├── prod.tfvars
│           └── backend.tf
│
├── database/
│   ├── migrations/
│   │   └── 001_create_tables.sql
│   │
│   └── seed/
│       └── seed.sql
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── docker-compose.yml
├── .gitignore
├── README.md
└── .github/
    └── workflows/
        └── terraform.yml
```

---

## 3. Prerequisites

Install the following tools:

* Git
* Docker
* Docker Compose
* Terraform
* AWS CLI
* GitHub account

Verify the installations:

```bash
git --version
docker --version
docker compose version
terraform version
aws --version
```

---

# 4. AWS Configuration

Configure AWS CLI credentials:

```bash
aws configure
```

Provide:

```text
AWS Access Key ID
AWS Secret Access Key
Default region: ap-south-1
Default output format: json
```

Verify the AWS identity:

```bash
aws sts get-caller-identity
```

The command should return the configured AWS account and IAM identity.

---

# 5. Terraform Development Environment

Go to the development environment:

```bash
cd infra/envs/dev
```

Initialize Terraform:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Generate an execution plan:

```bash
terraform plan -var-file="dev.tfvars"
```

If the database password is supplied separately:

```bash
terraform plan \
  -var-file="dev.tfvars" \
  -var="db_password=YOUR_PASSWORD"
```

The plan should be reviewed before any infrastructure is created.

---

# 6. Terraform Production Environment

Go to:

```bash
cd infra/envs/prod
```

Initialize Terraform:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt -recursive
```

Validate:

```bash
terraform validate
```

Generate the production plan:

```bash
terraform plan -var-file="prod.tfvars"
```

The production environment uses separate Terraform configuration and state from development.

---

# 7. Terraform Modules

The infrastructure is separated into reusable modules.

### Network Module

The network module creates:

* VPC
* Public subnets
* Private subnets
* Internet Gateway
* NAT Gateway
* Public route table
* Private route table

### ECS Module

The ECS module defines:

* ECS cluster
* Fargate task configuration
* ECS service
* IAM roles
* Security groups
* Application networking

### RDS Module

The RDS module defines:

* PostgreSQL RDS instance
* Private DB subnet group
* RDS security group
* Encryption at rest
* Automated backups
* Backup retention
* Private database accessibility

---

# 8. Local PostgreSQL Database

The database can be run locally using Docker Compose.

From the project root:

```bash
docker compose up -d
```

Check the container:

```bash
docker compose ps
```

The PostgreSQL container should become healthy.

---

# 9. Database Migration

Run the migration:

```bash
docker exec -i terraform-db-reliability-postgres \
  psql -U appuser -d appdb \
  < database/migrations/001_create_tables.sql
```

Verify the tables:

```bash
docker exec -it terraform-db-reliability-postgres \
  psql -U appuser -d appdb
```

Inside PostgreSQL:

```sql
\dt
```

Exit:

```sql
\q
```

---

# 10. Seed Data

Load sample data:

```bash
docker exec -i terraform-db-reliability-postgres \
  psql -U appuser -d appdb \
  < database/seed/seed.sql
```

Verify:

```bash
docker exec -it terraform-db-reliability-postgres \
  psql -U appuser -d appdb
```

Run:

```sql
SELECT * FROM users;
SELECT * FROM orders;
```

Exit:

```sql
\q
```

---

# 11. Database Backup

The backup script creates a PostgreSQL custom-format dump.

Make the script executable:

```bash
chmod +x scripts/backup.sh
```

Run:

```bash
./scripts/backup.sh
```

A backup file will be created inside:

```text
backups/
```

Example:

```text
backups/appdb_20261002_223000.dump
```

---

# 12. Database Restore

First identify the backup file:

```bash
ls backups/
```

Run the restore script:

```bash
chmod +x scripts/restore.sh
```

Then:

```bash
./scripts/restore.sh backups/appdb_YYYYMMDD_HHMMSS.dump
```

Verify the restored data:

```bash
docker exec -it terraform-db-reliability-postgres \
  psql -U appuser -d appdb
```

Then:

```sql
SELECT * FROM users;
SELECT * FROM orders;
```

---

# 13. Query Optimization

The project demonstrates PostgreSQL query optimization using indexes and `EXPLAIN ANALYZE`.

Example query:

```sql
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE user_id = 1;
```

The `orders.user_id` column has an index:

```sql
CREATE INDEX idx_orders_user_id
ON orders(user_id);
```

Another example:

```sql
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE status = 'completed';
```

The query execution plan can be inspected to determine whether PostgreSQL uses an index or performs a sequential scan.

---

# 14. Database Reliability Features

The project demonstrates the following database reliability practices:

* Automated PostgreSQL backups
* Backup restoration
* Database migrations
* Seed data
* Database indexes
* Query execution-plan analysis
* Encrypted AWS RDS storage
* Automated RDS backups
* Private RDS networking
* Security-group-based database access

---

# 15. Terraform CI Validation

GitHub Actions is configured to validate Terraform changes.

The workflow performs:

```bash
terraform fmt -check -recursive
terraform init
terraform validate
```

The workflow is located at:

```text
.github/workflows/terraform.yml
```

The CI workflow is intended to catch Terraform formatting and configuration errors before changes are merged.

---

# 16. Verification Checklist

Before submitting the assignment, verify:

### Terraform

```bash
terraform fmt -recursive
terraform validate
terraform plan
```

Both environments should validate successfully:

```text
infra/envs/dev
infra/envs/prod
```

### Docker

```bash
docker compose up -d
docker compose ps
```

### Database

Verify:

```sql
\dt
```

and:

```sql
SELECT * FROM users;
SELECT * FROM orders;
```

### Backup

```bash
./scripts/backup.sh
```

Confirm that a backup file exists.

### Restore

```bash
./scripts/restore.sh backups/<backup-file>
```

Verify that the database data is available after restoration.

### GitHub Actions

Push the repository and verify that the Terraform workflow completes successfully.

---

# 17. Cleanup

Stop the local database:

```bash
docker compose down
```

To also remove the PostgreSQL Docker volume:

```bash
docker compose down -v
```

Warning: removing the volume deletes the local PostgreSQL data.

For AWS resources, run:

```bash
terraform destroy
```

only when you intentionally want to remove infrastructure created by Terraform.

---

# 18. Security Notes

Do not commit AWS credentials, Terraform state containing secrets, passwords, or other sensitive values to GitHub.

The `.gitignore` file should exclude sensitive and generated files such as:

```text
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
!dev.tfvars
!prod.tfvars
*.tfplan
.env
backups/
```

Database passwords should preferably be supplied through variables, environment variables, or a secrets-management system rather than being hardcoded in Terraform configuration.

---

# 19. Assignment Scope

Actual AWS deployment is not required for this assessment.

The Terraform portion can be demonstrated through:

```bash
terraform fmt
terraform validate
terraform plan
```

The database portion can be demonstrated locally using:

```text
Docker Compose
PostgreSQL
SQL migrations
Seed data
Backup
Restore
EXPLAIN ANALYZE
```

This allows the infrastructure design and database reliability workflows to be reviewed without requiring a live production deployment.
