output "service_id" {
  description = "API Gateway service ID"
  value       = tencentcloud_api_gateway_service.this.id
}

output "service_url" {
  description = "API Gateway service default domain URL"
  value       = "https://${tencentcloud_api_gateway_service.this.service_id}.apigw.tencentcs.com"
}

output "api_ids" {
  description = "Map of route key to API ID"
  value       = { for k, v in tencentcloud_api_gateway_api.route : k => v.id }
}
