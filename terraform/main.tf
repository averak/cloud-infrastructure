module "dns" {
  source = "./modules/dns"

  domain = var.domain
}

module "ec2" {
  source = "./modules/ec2"

  domain = var.domain
}