variable "project_name" {
  type        = string
  default     = "agrium-k8s"
  description = "The project name used as name or prefix of all AWS resources."
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "The AWS region to create content in."
}

variable "vpc_cidr_block" {
  type        = string
  default     = "172.20.0.0/16"
  description = "The CIDR block of the VPC."
}


variable "vpc_public_subnets" {
  type        = list(string)
  default     = ["172.20.0.0/22", "172.20.4.0/22", "172.20.8.0/22"]
  description = "A list of public subnets inside the VPC where EKS will instantiate the Elastic Load Balancer."
}

variable "vpc_private_subnets" {
  type        = list(string)
  default     = ["172.20.100.0/22", "172.20.104.0/22", "172.20.108.0/22"]
  description = "A list of private subnets inside the VPC where the worker nodes will run."
}

variable "vpc_extra_tags" {
  type        = map(string)
  description = "Extra AWS tags to be applied to created resources."
  default     = {}
}

variable "kops_state_store_s3_bucket" {
  type        = string
  default     = "agrium-k8-kops-state-store"
  description = "S3 bucket where we store kops state."
}
