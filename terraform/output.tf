output "private_key" {
  value = tls_private_key.kops-key.private_key_pem
}
