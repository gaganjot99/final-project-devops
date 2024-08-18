terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }

  required_version = ">=0.14"
}
provider "aws" {
  region  = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  default_tags = merge(var.default_tags, { "env" = var.env })
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-vpc2"
    }
  )
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-private-subnet-${count.index}"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${var.prefix}-public-subnet-${count.index}"
    }
  )
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-route-table-private"
  }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-route-table-public"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet)
  route_table_id = aws_route_table.private_subnet_route_table.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.public_subnet_route_table.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}



