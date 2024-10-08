variable "private_cidr_blocks" {
  default     = ["10.1.5.0/24", "10.1.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

variable "public_cidr_blocks" {
  default     = ["10.1.1.0/24","10.1.2.0/24", "10.1.3.0/24","10.1.4.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

variable "vpc_cidr" {
  default     = "10.1.0.0/16"
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
  default = "group3"
  type        = string
  description = "Name prefix"
}

variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}