variable "function_name" {
  description = "SCF function name"
  type        = string
}

variable "description" {
  description = "Function description"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "SCF runtime (e.g. Nodejs18.15)"
  type        = string
  default     = "Nodejs18.15"
}

variable "handler" {
  description = "Function entry point (file.handler)"
  type        = string
  default     = "index.main_handler"
}

variable "memory_size" {
  description = "Memory size in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 10
}

# COS deployment — reserved for future CI/CD code deployment.
# Currently using inline zip_file (bootstrap mode).
variable "cos_bucket" {
  description = "COS bucket name for the deployment package (reserved for future COS deployment)"
  type        = string
  default     = ""
}

variable "cos_object_key" {
  description = "COS object key (path) for the deployment zip (reserved for future COS deployment)"
  type        = string
  default     = ""
}

variable "cos_bucket_region" {
  description = "COS bucket region (e.g. ap-hongkong)"
  type        = string
  default     = "ap-hongkong"
}

variable "environment" {
  description = "Environment variables for the function"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID (required for DB access)"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID (required for DB access)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "enable_http_trigger" {
  description = "Whether to create an HTTP trigger (Function URL) for direct HTTP access"
  type        = bool
  default     = false
}
