terraform {
  required_version = ">= 0.12.8"

  // See https://github.com/hashicorp/terraform/issues/13022
  backend "s3" {
    key    = "terraform.tfstate"
  }
}
