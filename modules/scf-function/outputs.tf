output "function_name" {
  description = "SCF function name"
  value       = tencentcloud_scf_function.this.name
}

output "function_id" {
  description = "SCF function ID"
  value       = tencentcloud_scf_function.this.id
}

output "http_trigger_url" {
  description = "HTTP trigger (Function URL) endpoint, if enabled"
  value       = length(tencentcloud_scf_trigger_config.http) > 0 ? tencentcloud_scf_function.this.trigger_info : null
}
