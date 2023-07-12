module "frontend" {
  source      = "./frontend"
  environment = var.environment
}

module "backend" {
  source      = "./backend"
  environment = var.environment
}
