provider "aws" {
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "prod-gaganjot-bucket"     
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}