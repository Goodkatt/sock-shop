module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "159.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["159.0.1.0/24", "159.0.2.0/24", "159.0.3.0/24", "159.0.4.0/24", "159.0.5.0/24", "159.0.6.0/24"]
  public_subnets  = ["159.0.10.0/24", "159.0.20.0/24", "159.0.30.0/24", "159.0.40.0/24", "159.0.50.0/24", "159.0.60.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/example" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/example" = "shared"
  }
}