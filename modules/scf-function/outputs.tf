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
  # NOTE: The 'host' computed attribute is only populated for func_type=HTTP functions.
  # For Event-type functions with inline HTTP triggers, the URL must be retrieved
  # via the SCF ListTriggers API (NetConfig.ExtranetUrl in TriggerDesc).
  value = tencentcloud_scf_function.this.host != "" ? "https://${tencentcloud_scf_function.this.host}" : null
}
