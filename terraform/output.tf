output "private_key" {
  value = tls_private_key.kops-key.private_key_pem
}
output "kops_id" {
  value = aws_iam_access_key.kops_access_key.id
}
output "kops_secret" {
  value = aws_iam_access_key.kops_access_key.secret
}
output "build-toolbox-ecr" {
  value = aws_ecr_repository.build-toolbox.repository_url
}
output "vpc-id" {
  value = module.vpc.vpc_id
}
output "private-subnets" {
  value = module.vpc.private_subnets
}
output "public-subnets" {
  value = module.vpc.public_subnets
}
output "aws-region" {
  value = var.aws_region
}
