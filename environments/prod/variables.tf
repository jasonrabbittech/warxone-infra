variable "region" {
  description = "Tencent Cloud region"
  type        = string
  default     = "ap-hongkong"
}

variable "app_id" {
  description = "Tencent Cloud APPID"
  type        = string
  default     = "1376958570"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "warxone"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Common tags for all resources (app: prefix to avoid Tencent Cloud reserved keys)"
  type        = map(string)
  default = {
    "app:project"    = "warxone"
    "app:env"        = "prod"
    "app:managed-by" = "terraform"
    "app:owner"      = "isaac"
  }
}

variable "db_password" {
  description = "Database password for application user"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT signing secret"
  type        = string
  sensitive   = true
}

variable "google_client_id" {
  description = "Google OAuth 2.0 Client ID"
  type        = string
  default     = ""
}

variable "google_client_secret" {
  description = "Google OAuth 2.0 Client Secret"
  type        = string
  sensitive   = true
  default     = ""
}
