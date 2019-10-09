output "private-key" {
  value = tls_private_key.kops-key.private_key_pem
}
output "kops-id" {
  value = aws_iam_access_key.kops_access_key.id
}
output "kops-secret" {
  value = aws_iam_access_key.kops_access_key.secret
}
output "build-toolbox-ecr" {
  value = aws_ecr_repository.build-toolbox.repository_url
}
output "kops-values" {
  value = <<EOT
vpcid: ${module.vpc.vpc_id}
awsregion: ${var.aws_region}
name: ${var.project_name}
statebucket: ${var.kops_state_store_s3_bucket}
EOT
}
output "nets" {
  value = <<EOT
- cidr: ${module.vpc.public_subnets_cidr_blocks[0]}
  name: ${var.project_name}-public-${var.aws_region}a
  type: Utility
  id: ${module.vpc.public_subnets[0]}
- cidr: ${module.vpc.public_subnets_cidr_blocks[1]}
  name: ${var.project_name}-public-${var.aws_region}b
  type: Utility
  id: ${module.vpc.public_subnets[1]}
- cidr: ${module.vpc.public_subnets_cidr_blocks[2]}
  name: ${var.project_name}-public-${var.aws_region}c
  type: Utility
  id: ${module.vpc.public_subnets[2]}
- cidr: ${module.vpc.private_subnets_cidr_blocks[0]}
  name: ${var.project_name}-private-${var.aws_region}a
  type: Private
  id: ${module.vpc.private_subnets[0]}
- cidr: ${module.vpc.private_subnets_cidr_blocks[1]}
  name: ${var.project_name}-private-${var.aws_region}b
  type: Private
  id: ${module.vpc.private_subnets[1]}
- cidr: ${module.vpc.private_subnets_cidr_blocks[2]}
  name: ${var.project_name}-private-${var.aws_region}c
  type: Private
  id: ${module.vpc.private_subnets[2]}
EOT
}
