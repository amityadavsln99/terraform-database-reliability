output "vpc_id" {
  description = "Production VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Production public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Production private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "ecs_cluster_id" {
  description = "Production ECS cluster ID"
  value       = module.ecs.cluster_id
}

output "ecs_service_name" {
  description = "Production ECS service name"
  value       = module.ecs.service_name
}

output "alb_dns_name" {
  description = "Production ALB DNS name"
  value       = module.ecs.alb_dns_name
}

output "rds_endpoint" {
  description = "Production RDS endpoint"
  value       = module.rds.db_endpoint
}

output "rds_security_group_id" {
  description = "Production RDS security group ID"
  value       = module.rds.security_group_id
}