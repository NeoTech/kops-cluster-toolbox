resource "aws_security_group" "worker" {
  name        = format("%s-workerSG", var.project_name)
  description = "Communication between loadbalancer and the nodes"
  vpc_id      = module.vpc.vpc_id
  tags = merge(
    map(
      "Name", format("%s-workerSG", var.project_name),
      format("kubernetes.io/cluster/%s", var.project_name), "owned",
      "kuberntes:application", "kube-aws-ingress-controller"
    )
  )

}
resource "aws_security_group" "kube_ingress" {
  name        = format("%s-IngressSG", var.project_name)
  description = "Communication between nodes and the internet/intranet"
  vpc_id      = module.vpc.vpc_id

  tags = merge(
    map(
      "Name", format("%s-IngressSG", var.project_name),
      format("kubernetes.io/cluster/%s", var.project_name), "owned",
      "kubernetes:application",  "kube-ingress-aws-controller"
    )
  )
}

resource "aws_security_group_rule" "ingress_internet_ssl" {
  description              = "Allow worker nodes to communicate with the internet"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.kube_ingress.id
}

resource "aws_security_group_rule" "egress_kube_ingress_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.kube_ingress.id
}

resource "aws_security_group_rule" "ingress_internet_plain" {
  description              = "Allow worker nodes to communicate with the internet"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.kube_ingress.id
}

resource "aws_security_group_rule" "kube_ingress_worker_allow_all" {
  type                     = "ingress"
  description              = "Allow ALB to push traffic to the nodes"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.kube_ingress.id
}
