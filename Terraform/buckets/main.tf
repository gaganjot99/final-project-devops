terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "b_one" {
  bucket = "prod-gaganjot-bucket"

  tags = {
    Name        = "Production bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket" "b_two" {
  bucket = "dev-gaganjot-bucket"

  tags = {
    Name        = "Development bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "gaganjot-images"
}

resource "aws_s3_bucket_ownership_controls" "own_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.own_bucket]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "image_files" {
  for_each = fileset("${path.module}/images", "*")
  bucket   = aws_s3_bucket.my_bucket.bucket
  key      = each.value
  source   = "${path.module}/images/${each.value}"
  acl      = "public-read"
}

output "image_urls" {
  value = [for image in aws_s3_object.image_files : "https://${aws_s3_bucket.my_bucket.bucket}.s3.amazonaws.com/${image.key}"]
}