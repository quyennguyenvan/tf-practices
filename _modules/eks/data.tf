data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_vpc" "eks" {
  id = var.vpc_id
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.eks.id

  tags = {
    Name = "${var.cluster-name}-eks-private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.eks.id

  tags = {
    Name = "${var.cluster-name}-eks-public"
  }
}

data "aws_security_group" "cluster" {
  vpc_id = data.aws_vpc.eks.id
  name   = module.cluster-sg.this_security_group_name
}

data "aws_security_group" "node" {
  vpc_id = data.aws_vpc.eks.id
  name   = module.node-sg.this_security_group_name
}

data "aws_security_group" "bastion" {
  vpc_id = data.aws_vpc.eks.id
  name   = module.ssh_sg.this_security_group_name
}
