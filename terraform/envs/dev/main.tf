locals {
  name = "${var.project_name}-${var.environment}"
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source               = "../../modules/vpc"
  name                 = local.name
  vpc_cidr             = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = "${local.name}-eks"
  tags                 = local.tags
}

module "iam" {
  source = "../../modules/iam"
  name   = local.name
  tags   = local.tags
}

module "eks" {
  source              = "../../modules/eks"
  name                = local.name
  cluster_name        = "${local.name}-eks"
  cluster_version     = var.cluster_version
  cluster_role_arn    = module.iam.eks_cluster_role_arn
  node_role_arn       = module.iam.eks_node_role_arn
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = var.node_instance_types
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
  tags                = local.tags

  depends_on = [module.iam]
}

module "ecr" {
  source = "../../modules/ecr"
  name   = "${local.name}-app"
  tags   = local.tags
}

module "alb" {
  source            = "../../modules/alb"
  name              = local.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  tags              = local.tags
}

module "jenkins" {
  source        = "../../modules/jenkins"
  enabled       = var.enable_jenkins
  name          = "${local.name}-jenkins"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  instance_type = "t3.micro"
  tags          = local.tags
}
