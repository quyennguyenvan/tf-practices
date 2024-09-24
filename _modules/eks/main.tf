locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.1"
  # manage_aws_auth = false
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_name                   = var.eks_cluster_name
  cluster_version                = var.eks_cluser_enginee_version
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnet_ids

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  ## https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
  # enable_irsa = true

  self_managed_node_group_defaults = {
    ami_id = var.ami_id
  }

  self_managed_node_groups = [

    for private_subnet in var.private_subnet_ids : {
      launch_template_name = var.eks_cluster_name

      worker_groups = {
        name          = "${var.eks_cluster_name}-eks-worker-ondemand-${private_subnet}"
        instance_type = var.instance_types
        subnets       = tolist([private_subnet])

        ami_id = var.ami_id

        max_size            = var.min_size
        min_size            = var.max_size
        desired_size        = var.desired_size
        kubelete_extra_args = "-kubelet-extra-args '--node-labels=kubernetes.io/lifecycle=normal'"
        public_ip           = false
        kubelete_extra_args = "-kubelet-extra-args '--node-labels=kubernetes.io/lifecycle=normal'"

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

        tags = [
          {
            "key"                 = "k8s.io/cluster-autoscaler/${var.eks_cluster_name}-eks-cluster"
            "value"               = "owned"
            "propagate_at_launch" = true
          },
          {
            "key"                 = "k8s.io/cluster-autoscaler/enabled"
            "value"               = "true"
            "propagate_at_launch" = true
          }
        ]
      }
    }
  ]
  enable_cluster_creator_admin_permissions = true
  access_entries = {
    # One access entry with a policy associated
    this = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::084375555299:user/quyennv_user"

      policy_associations = {
        this = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            # namespaces = ["default"]
            type = "cluster"
          }
        }
      }
    }
  }
  tags = var.tags
}
