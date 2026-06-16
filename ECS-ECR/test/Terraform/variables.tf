variable aws_region{
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "ap-south-1"
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
}


variable "cluster_name" { 
    description = "The name of the ECS cluster"
    type        = string
    default     = "bankapp-dev-cluster"
}
      
