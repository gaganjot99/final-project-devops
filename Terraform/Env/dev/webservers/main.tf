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

resource "aws_lb" "aws_lb" {
  name               = "group3-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sgs.sg_id]
  subnets            = data.terraform_remote_state.networks.outputs.public_subnet_ids

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  idle_timeout = 60

  tags = {
    Name = "${var.prefix}-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "group3-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.networks.outputs.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }

  tags = {
    Name = "${var.prefix}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.aws_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_a" {
  count              = length(module.webservers.public_instances_ids)
  target_group_arn   = aws_lb_target_group.tg.arn
  target_id          = module.webservers.public_instances_ids[count.index]
  port               = 80
}

resource "aws_lb_target_group_attachment" "tg_b" {
  count              = length(module.webservers.private_instances_ids)
  target_group_arn   = aws_lb_target_group.tg.arn
  target_id          = module.webservers.private_instances_ids[count.index]
  port               = 80
}