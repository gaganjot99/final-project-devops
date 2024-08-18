module "vpc-dev" {
  source = "git::https://github.com/gaganjot99/terraform-modules/tree/main/network"
  default_tags       = var.default_tags
}