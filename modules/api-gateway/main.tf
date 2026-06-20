# API Gateway Service
resource "tencentcloud_api_gateway_service" "this" {
  service_name = var.service_name
  protocol     = var.protocol
  net_type     = join(",", var.net_type)
  ip_version   = "IPv4"

  tags = merge(var.tags, { Module = "api-gateway" })
}

# Create an API for each route, binding to SCF
resource "tencentcloud_api_gateway_api" "route" {
  for_each = { for r in var.routes : "${r.method}-${r.path}" => r }

  service_id    = tencentcloud_api_gateway_service.this.id
  api_name      = replace(replace(each.value.path, "/", "-"), "-", "_")}_${each.value.method}
  api_desc      = "${each.value.method} ${each.value.path}"
  protocol      = "HTTP"
  request_method = each.value.method
  request_path   = each.value.path
  auth_type      = "NONE"

  # SCF backend integration
  service_type        = "SCF"
  service_scfs {
    function_name = each.value.function_name
    namespace     = "default"
    is_integrated_response = true
  }
}

# Release the service
resource "tencentcloud_api_gateway_service_release" "this" {
  service_id       = tencentcloud_api_gateway_service.this.id
  environment_name = var.environment_name
  release_desc     = "Initial release"

  depends_on = [tencentcloud_api_gateway_api.route]
}
