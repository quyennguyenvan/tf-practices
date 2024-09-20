locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.1"
  # manage_aws_auth = false

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluser_enginee_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  ## https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
  # enable_irsa = true

  self_managed_node_groups = [

    for private_subnet in var.private_subnet_ids : {
      launch_template_name = var.eks_cluster_name

      worker_group = {
        name          = "${var.eks_cluster_name}-eks-worker-ondemand-${private_subnet}"
        instance_type = var.instance_types
        subnets       = tolist([private_subnet])

        ami_id = var.ami_id

        max_size            = var.min_size
        min_size            = var.max_size
        desired_size        = var.desired_size
        kubelete_extra_args = "-kubelet-extra-args '--node-labels=kubernetes.io/lifecycle=normal'"
        public_ip           = false

        # root_volume_type = "gp2"
        block_device_mappings = {
          xvda = {
            device_name = "/dev/xvda"
            ebs = {
              delete_on_termination = true
              encrypted             = true
              volume_size           = 100
              volume_type           = "gp2"
            }
          }
        }
      }
    }
  ]
  tags = var.tags
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.24.1"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "${module.eks.cluster_iam_role_arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/quyennv_user"
      username = "quyennv_user"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    local.account_id
  ]
}
