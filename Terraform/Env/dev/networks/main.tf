module "vpc-dev" {
  source = "../../../Modules/network"
  default_tags       = var.default_tags
}