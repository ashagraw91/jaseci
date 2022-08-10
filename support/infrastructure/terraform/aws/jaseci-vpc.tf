# # LARES Main VPC 

# resource "aws_vpc" "zsb-vpc" {
#   cidr_block                       = "172.20.0.0/16"
#   instance_tenancy                 = "default"
#   enable_dns_support               = true
#   enable_dns_hostnames             = true
#   enable_classiclink               = false
#   enable_classiclink_dns_support   = false
#   assign_generated_ipv6_cidr_block = false
#   tags = {
#     "Name"                                = "zsb-vpc"
#     "kubernetes.io/cluster/zsb-cluster" = "shared"
#   }
# }
variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}


data "aws_availability_zones" "available" {}

locals {
  cluster_name = format("%s-%s", "zsb-eks", local.envsuffix)
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = format("%s-%s", "zsb-vpc", local.envsuffix)
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}