output "tfstate_bucket" {
  description = "Terraform state bucket name"
  value       = module.tfstate_bucket.bucket_name
}

output "game_bucket" {
  description = "Game static assets bucket name"
  value       = module.game_bucket.bucket_name
}

output "game_website_url" {
  description = "Game static website URL (COS fallback)"
  value       = module.game_bucket.website_endpoint
}

output "scf_deploy_bucket" {
  description = "COS bucket for SCF deployment packages"
  value       = module.scf_deploy_bucket.bucket_name
}

output "database_host" {
  description = "TDSQL-C internal connection address"
  value       = module.database.host
}

output "database_port" {
  description = "TDSQL-C connection port"
  value       = module.database.port
}

output "api_gateway_url" {
  description = "API Gateway service URL"
  value       = module.api_gateway.service_url
}

output "scf_function_names" {
  description = "Map of SCF function names"
  value       = { for k, v in module.scf : k => v.function_name }
}
