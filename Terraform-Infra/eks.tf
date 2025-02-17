module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "example"
  cluster_version = "1.31"
  iam_role_arn = "arn:aws:iam::721699489018:role/AmazonEKSAutoClusterRole"
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access = true
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_private_access = true


  cluster_addons = {
    coredns                = {
        #version = "v1.11.4-eksbuild.2"
        resolve_conflicts = "OVERWRITE"
    }

    kube-proxy             = {
        #version = "v1.31.3-eksbuild.2"
        resolve_conflicts = "OVERWRITE"
    }
    # eks-pod-identity-agent = {
    #     version = "v1.19.2-eksbuild.1"
    # }
    vpc-cni                = {
        #service_account_role_arn = "arn:aws:iam::721699489018:role/AmazonEKSPodIdentityAmazonVPCCNIRole"
        #version = "v1.19.2-eksbuild.1"
        before_compute = true
        service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
        resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = { most_recent = true }
  }
  
  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true
    ami_type = "AL2_x86_64"
  }
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"
      iam_role_arn = "arn:aws:iam::721699489018:instance-profile/AmazonEKSNodeRole"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 4
      desired_size = 1
      subnet_ids = module.vpc.private_subnets
      iam_role_additional_policies = { AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" }
    }

  }
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "vpc-cni"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}