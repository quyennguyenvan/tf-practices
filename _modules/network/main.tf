locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                 = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]
  elasticache_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 12)]
  redshift_subnets    = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 16)]
  intra_subnets       = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 20)]

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.single_nat_gateway ? false : true
  enable_dns_hostnames   = var.enable_dns_hostnames

  create_database_subnet_group           = var.create_database_subnet_group
  create_database_subnet_route_table     = var.create_database_subnet_route_table
  create_database_internet_gateway_route = var.create_database_internet_gateway_route

  enable_flow_log                       = var.enable_flow_log
  vpc_flow_log_iam_role_name            = "${var.vpc_name}-follow-log-role"
  vpc_flow_log_iam_role_use_name_prefix = false
  create_flow_log_cloudwatch_iam_role   = var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group  = var.create_flow_log_cloudwatch_log_group
  flow_log_max_aggregation_interval     = 60

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.default_tags
}
