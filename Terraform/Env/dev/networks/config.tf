provider "aws" {
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "dev-gaganjot-bucket"     
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}