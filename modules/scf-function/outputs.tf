output "function_name" {
  description = "SCF function name"
  value       = tencentcloud_scf_function.this.function_name
}

output "function_id" {
  description = "SCF function ID"
  value       = tencentcloud_scf_function.this.id
}
