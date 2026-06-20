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
  # The 'host' computed attribute contains the Function URL domain
  # It may be empty for Event-type functions without HTTP triggers
  value = tencentcloud_scf_function.this.host
}
