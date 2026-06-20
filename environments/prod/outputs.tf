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

output "scf_function_names" {
  description = "Map of SCF function names"
  value       = { for k, v in module.scf : k => v.function_name }
}

output "scf_function_urls" {
  description = "Map of SCF function HTTP trigger (Function URL) endpoints"
  value       = { for k, v in module.scf : k => v.http_trigger_url }
}
