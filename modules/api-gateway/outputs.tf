output "service_id" {
  description = "API Gateway service ID (same as resource id)"
  value       = tencentcloud_api_gateway_service.this.id
}

output "service_url" {
  description = "API Gateway service public URL"
  value       = "https://${tencentcloud_api_gateway_service.this.outer_sub_domain}"
}

output "api_ids" {
  description = "Map of route key to API ID"
  value       = { for k, v in tencentcloud_api_gateway_api.route : k => v.id }
}
