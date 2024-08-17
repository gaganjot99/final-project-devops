variable "default_tags" {
  default = {
    "Owner" = "Gaganjot"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "group3"
  type        = string
  description = "Name prefix"
}