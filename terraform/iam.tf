# Not popping out credentials ? How do we use ?
resource "aws_iam_user" "kops" {
  name = "kops"

  tags = {
    "Name" = var.project_name
  }
}

resource "aws_iam_access_key" "kops_access_key" {
  user = "${aws_iam_user.kops.name}"
}

resource "aws_iam_user_policy_attachment" "kops_ec2_full_access" {
  user       = aws_iam_user.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "kops_route53_full_access" {
  user       = aws_iam_user.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

// Do we need this ?
resource "aws_iam_user_policy_attachment" "kops_iam_full_access" {
  user       = aws_iam_user.kops.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

// Do we need this ?
resource "aws_iam_user_policy_attachment" "kops_vpc_full_access" {
  user       = aws_iam_user.kops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_user_policy" "kops_s3_state_store_full_access" {
  name = "state_store_policy"
  user = aws_iam_user.kops.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.kops_state_store.arn}/*"
    }
  ]
}
EOF
}
