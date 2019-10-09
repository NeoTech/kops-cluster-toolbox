provider "aws" {
  version = ">= 2.31.0"
  region  = var.aws_region
}

data "aws_availability_zones" "azs" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = var.project_name

  cidr = var.vpc_cidr_block

  azs = data.aws_availability_zones.azs.names

  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  // Private subnets in your VPC should be tagged accordingly so that 
  // Kubernetes knows that it can use them for internal load balancers
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "SubnetType" = "Private"
  }

  public_subnet_tags = {
    "SubnetType" = "Utility",
    "kubernetes.io/role/elb" = "1"
  }
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = merge(
    {
      "kubernetes.io/cluster/${var.project_name}" = "shared"
    },
    var.vpc_extra_tags,
  )
}

resource "aws_s3_bucket" "kops_state_store" {
  bucket = var.kops_state_store_s3_bucket
  acl    = "private"
}

module "ingress_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr_block]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
}

