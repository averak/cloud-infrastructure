module "vpc" {
  source = "./modules/vpc"

  domain = var.domain
}

module "dns" {
  source = "./modules/dns"

  domain = var.domain
}

module "ec2" {
  source = "./modules/ec2"

  domain           = var.domain
  vpc_id           = module.vpc.id
  public_subnet_id = module.vpc.public_subnet_ids[0]
}

module "load_balancer" {
  source = "./modules/load_balancer"

  domain            = var.domain
  ec2_instance_id   = module.ec2.instance_id
  certificate_arn   = module.dns.certificate_arn
  vpc_id            = module.vpc.id
  public_subnet_ids = module.vpc.public_subnet_ids
}