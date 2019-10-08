resource "tls_private_key" "kops-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "kops-ssh-key" {
  key_name   = "kops-ssh-key"
  public_key = tls_private_key.kops-key.public_key_openssh
}
