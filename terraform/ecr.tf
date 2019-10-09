resource "aws_ecr_repository" "build-toolbox" {
  name = "build-toolbox"
  tags = {
    Environment = "circlci",
    Owner = "management-cluster"
  }
}
