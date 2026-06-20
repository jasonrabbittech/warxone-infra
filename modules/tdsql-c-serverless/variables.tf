variable "instance_name" {
  description = "TDSQL-C instance name"
  type        = string
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "5.7"
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ap-hongkong-1"
}

variable "vpc_id" {
  description = "VPC ID for the instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "db_username" {
  description = "Application database username"
  type        = string
  default     = "warxone_app"
}

variable "db_password" {
  description = "Application database password"
  type        = string
  sensitive   = true
}

variable "pay_type" {
  description = "0 = postpaid (pay-as-you-go), 1 = prepaid"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
