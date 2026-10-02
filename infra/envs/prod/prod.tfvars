aws_region = "ap-south-1"

project_name = "terraform-db-reliability-prod"

vpc_cidr = "10.1.0.0/16"

azs = [
  "ap-south-1a",
  "ap-south-1b"
]

public_subnet_cidrs = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]

private_subnet_cidrs = [
  "10.1.11.0/24",
  "10.1.12.0/24"
]

container_image = "nginx:alpine"
container_port  = 80

ecs_cpu           = 256
ecs_memory        = 512
ecs_desired_count = 2

health_check_path = "/"

db_name     = "appdb"
db_username = "appuser"

db_instance_class          = "db.t3.micro"
db_allocated_storage       = 20
db_backup_retention_period = 7
db_deletion_protection     = true