module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19.0"

  name                    = "${local.resource_prefix}-vpc"
  cidr                    = "10.0.0.0/16"
  azs                     = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets          = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets         = ["10.0.10.0/24", "10.0.11.0/24"]
  enable_dns_hostnames    = true
  map_public_ip_on_launch = false
  enable_nat_gateway      = true
  single_nat_gateway      = true
}