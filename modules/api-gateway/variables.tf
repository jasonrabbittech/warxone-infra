variable "service_name" {
  description = "API Gateway service name"
  type        = string
}

variable "protocol" {
  description = "Service protocol"
  type        = string
  default     = "http&https"
}

variable "net_type" {
  description = "Network type (OUTER for public, INNER for VPC)"
  type        = list(string)
  default     = ["OUTER"]
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "routes" {
  description = "List of API routes to create"
  type = list(object({
    path          = string
    method        = string
    function_name = string
  }))
  default = []
}

variable "environment_name" {
  description = "Environment name for release (e.g. release)"
  type        = string
  default     = "release"
}
