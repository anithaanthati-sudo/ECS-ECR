variable "name_prefix" {
  description = "Prefix used for naming ECS resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks."
  type        = list(string)
}

variable "ecr_repository_url" {
  description = "ECR repository URL."
  type        = string
}

variable "container_port" {
  description = "Container port exposed by the app."
  type        = number
}

variable "desired_count" {
  description = "Desired ECS task count."
  type        = number
}
