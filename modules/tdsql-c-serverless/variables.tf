variable "instance_name" {
  description = "TDSQL-C cluster name"
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
  default     = "ap-hongkong-2"
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
  description = "Database password (root and app user)"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
