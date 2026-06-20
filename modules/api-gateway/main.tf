# API Gateway Service
resource "tencentcloud_api_gateway_service" "this" {
  service_name = var.service_name
  protocol     = var.protocol
  net_type     = toset(var.net_type)
  ip_version   = "IPv4"

  tags = merge(var.tags, { Module = "api-gateway" })
}

# Create an API for each route, binding to SCF
# Schema source: tencentcloudstack/terraform-provider-tencentcloud
# - request_config_path (required): frontend path
# - request_config_method: frontend HTTP method
# - service_config_type: backend type (SCF)
# - service_config_scf_*: flat SCF integration attributes (NOT a nested block)
resource "tencentcloud_api_gateway_api" "route" {
  for_each = { for r in var.routes : "${r.method}-${r.path}" => r }

  service_id = tencentcloud_api_gateway_service.this.id
  api_name   = "${replace(replace(each.value.path, "/", "-"), "-", "_")}_${each.value.method}"
  api_desc   = "${each.value.method} ${each.value.path}"
  protocol   = "HTTP"

  # Frontend request configuration
  request_config_path   = each.value.path
  request_config_method = each.value.method

  auth_type   = "NONE"
  enable_cors = true

  # SCF backend integration (flat attributes, NOT a block)
  service_config_type                           = "SCF"
  service_config_scf_function_name              = each.value.function_name
  service_config_scf_function_namespace         = "default"
  service_config_scf_function_qualifier         = "$LATEST"
  service_config_scf_function_type              = "EVENT"
  service_config_scf_is_integrated_response     = true
  service_config_timeout                        = 15
}

# Release the service
resource "tencentcloud_api_gateway_service_release" "this" {
  service_id       = tencentcloud_api_gateway_service.this.id
  environment_name = var.environment_name
  release_desc     = "Initial release"

  depends_on = [tencentcloud_api_gateway_api.route]
}
