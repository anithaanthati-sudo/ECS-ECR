output "ecr_repository_url" {
  description = "ECR repository URL used by CI/CD."
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name."
  value       = module.ecs.service_name
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name."
  value       = module.ecs.alb_dns_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for container logs."
  value       = module.ecs.cloudwatch_log_group
}
