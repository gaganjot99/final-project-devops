variable "private_cidr_blocks" {
  default     = ["10.2.5.0/24", "10.2.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

variable "public_cidr_blocks" {
  default     = ["10.2.1.0/24","10.2.2.0/24", "10.2.3.0/24","10.2.4.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

variable "vpc_cidr" {
  default     = "10.2.0.0/16"
  type        = string
  description = "VPC to hold everything"
}

# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

variable "prefix" {
  default = "terraform"
  type        = string
  description = "Name prefix"
}

variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}