module "dns" {
  source = "./modules/dns"

  domain = var.domain
}

module "ec2" {
  source = "./modules/ec2"

  domain = var.domain
}

module "load_balancer" {
  source = "./modules/load_balancer"

  domain          = var.domain
  ec2_instance_id = module.ec2.instance_id
  certificate_arn = module.dns.certificate_arn
}