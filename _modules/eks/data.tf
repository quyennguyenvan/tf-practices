data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_vpc" "eks" {
  id = var.vpc_id
}


data "aws_security_group" "cluster" {
  vpc_id = data.aws_vpc.eks.id
  name   = module.cluster-sg.this_security_group_name
}

data "aws_security_group" "node" {
  vpc_id = data.aws_vpc.eks.id
  name   = module.node-sg.this_security_group_name
}

