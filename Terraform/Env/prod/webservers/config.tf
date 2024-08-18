terraform {
  backend "s3" {
    bucket = "prod-gaganjot-bucket"           
    key    = "prod/webservers/terraform.tfstate" 
    region = "us-east-1"
  }
}