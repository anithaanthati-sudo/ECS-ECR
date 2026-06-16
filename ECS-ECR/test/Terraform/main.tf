module "vpc" {
    source = "./VPC"
    vpc_cidr = var.vpc_cidr

}

module "ecs" {
    source = "./ECS"
    cluster_name = var.cluster_name
    vpc_id = module.vpc.vpc_id
  
}