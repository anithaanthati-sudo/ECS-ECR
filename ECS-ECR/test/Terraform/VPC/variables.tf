variable "name_prefix" {
  description = "Prefix used for naming VPC resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}
