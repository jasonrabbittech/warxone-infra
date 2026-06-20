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
  # The 'host' attribute is populated by SCF when an HTTP trigger exists
  value = var.enable_http_trigger && tencentcloud_scf_function.this.host != "" ? "https://${tencentcloud_scf_function.this.host}" : null
}
