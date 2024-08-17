terraform {
  backend "s3" {
    bucket = "dev-gaganjot-bucket"           
    key    = "dev/webservers/terraform.tfstate" 
    region = "us-east-1"
  }
}