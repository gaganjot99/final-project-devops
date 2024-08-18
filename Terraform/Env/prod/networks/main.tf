module "vpc-prod" {
  source = "../../../Modules/network"
  default_tags       = var.default_tags
}