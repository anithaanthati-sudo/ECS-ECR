locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "vpc" {
  source      = "./VPC"
  name_prefix = local.name_prefix
  vpc_cidr    = var.vpc_cidr
}

resource "aws_ecr_repository" "app" {
  name                 = local.name_prefix
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

module "ecs" {
  source = "./ECS"

  name_prefix        = local.name_prefix
  environment        = var.environment
  aws_region         = var.aws_region
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  ecr_repository_url = aws_ecr_repository.app.repository_url
  container_port     = var.container_port
  desired_count      = var.desired_count
}
