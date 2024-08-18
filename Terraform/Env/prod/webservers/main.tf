provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "terraform_remote_state" "networks" {
  backend = "s3"
  config = {
    bucket = "dev-gaganjot-bucket"          
    key    = "dev/network/terraform.tfstate" 
    region = "us-east-1"         
  }
}

module "sgs" {
  source = "../../../Modules/sg"
  vpc_id = data.terraform_remote_state.networks.outputs.vpc_id
}

resource "aws_key_pair" "My_key" {
  key_name   = var.prefix
  public_key = file("${var.prefix}.pub")
}

module "webservers" {
  source = "../../../Modules/webserver"
  public_subnet_ids = data.terraform_remote_state.networks.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.networks.outputs.private_subnet_ids
  public_sgs_ids = [module.sgs.sg_id]
  private_sgs_ids = [module.sgs.sg_id]
  key_name = aws_key_pair.My_key.key_name
  default_tags       = var.default_tags
}