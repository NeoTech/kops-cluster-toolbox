output "private_key" {
  value = tls_private_key.kops-key.private_key_pem
}

output "kops_id" {
  value = aws_iam_access_key.kops_access_key.id
}

output "kops_secret" {
  value = aws_iam_access_key.kops_access_key.secret
}
