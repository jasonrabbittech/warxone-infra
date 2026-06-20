# SCF Function — placeholder inline deployment
# Schema source: tencentcloudstack/terraform-provider-tencentcloud
#
# BOOTSTRAP MODE: Uses inline zip_file with a placeholder handler.
# This removes the dependency on pre-existing COS deployment packages.
# When actual function code is ready, deploy via CI/CD:
#   1. Upload ZIP to COS bucket
#   2. Call SCF UpdateFunctionCode API
# The lifecycle block prevents Terraform from reverting CI/CD code updates.

# Create ZIP archive from placeholder handler
data "archive_file" "placeholder" {
  type        = "zip"
  source_file = "${path.module}/placeholder/index.js"
  output_path = "${path.module}/placeholder.zip"
}

resource "tencentcloud_scf_function" "this" {
  name        = var.function_name
  description = var.description
  runtime     = var.runtime
  handler     = var.handler
  mem_size    = var.memory_size
  timeout     = var.timeout

  # NOTE: func_type defaults to "Event" — Event-type functions CAN have HTTP triggers.
  # Changing func_type on an existing function is NOT supported by the SCF API.
  # To switch to "HTTP" type, the function must be deleted and recreated.

  # Inline deployment from local ZIP (bootstrap mode)
  # Conflicts with cos_bucket_name / cos_object_name / cos_bucket_region
  zip_file = data.archive_file.placeholder.output_path

  # Environment variables (TypeMap, not a block)
  environment = length(var.environment) > 0 ? var.environment : null

  # VPC config for DB access (flat attributes, not a block)
  vpc_id    = var.vpc_id != "" ? var.vpc_id : null
  subnet_id = var.subnet_id != "" ? var.subnet_id : null

  tags = merge(var.tags, { "app:module" = "scf-function" })

  # Inline HTTP trigger (Function URL)
  # Uses CreateTrigger API (NOT UpdateTrigger), which works correctly for HTTP triggers.
  # The separate tencentcloud_scf_trigger_config resource uses UpdateTrigger API
  # which returns ResourceNotFound for HTTP triggers.
  dynamic "triggers" {
    for_each = var.enable_http_trigger ? [1] : []
    content {
      name         = "http-trigger"
      type         = "http"
      trigger_desc = jsonencode({
        AuthType  = "NONE"
        NetConfig = {
          EnableIntranet = true
          EnableExtranet = true
        }
      })
    }
  }

  # Allow CI/CD to update function code without Terraform reverting it.
  # Also ignore triggers to avoid perpetual drift from trigger_desc read bug:
  # the provider parses HTTP trigger_desc as a timer-trigger struct, reading
  # it back as empty, causing diff on every plan.
  lifecycle {
    ignore_changes = [zip_file, triggers]
  }
}
