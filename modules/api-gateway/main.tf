# API Gateway Service
resource "tencentcloud_api_gateway_service" "this" {
  service_name = var.service_name
  protocol     = var.protocol
  net_type     = var.net_type
  ip_version   = "IPv4"

  tags = merge(var.tags, { Module = "api-gateway" })
}

# Create an API for each route
resource "tencentcloud_api_gateway_api" "route" {
  for_each = { for r in var.routes : "${r.method}-${r.path}" => r }

  service_id    = tencentcloud_api_gateway_service.this.id
  api_name      = "${replace(each.value.path, "/", "-")}-${each.value.method}"
  api_desc      = "${each.value.method} ${each.value.path}"
  protocol      = "HTTP"
  request_mode  = each.value.request_mode
  auth_type     = "NONE"  # JWT verified inside SCF

  request_config {
    method = each.value.method
    path   = each.value.path
  }

  # SCF integration
  service_config {
    service_type      = "SCF"
    scf_function_name = each.value.function_name
    scf_namespace     = "default"
    scf_is_integrated = true
    scf_synchronous   = true
  }

  # Response config
  response_config {
    response_type = "HTML"
    success_response = "{\"success\":true}"
    error_response   = "{\"success\":false}"
  }
}

# Release the service
resource "tencentcloud_api_gateway_service_release" "this" {
  service_id      = tencentcloud_api_gateway_service.this.id
  environment_name = var.environment_name
  release_desc     = "Initial release"

  depends_on = [tencentcloud_api_gateway_api.route]
}
