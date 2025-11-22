module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  azs                 = var.azs
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "eks" {
  source              = "./modules/eks"
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  key_name            = var.key_name
  node_instance_types = var.node_instance_types
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_desired_count  = var.node_desired_count
}