# SCF Function deployed from COS bucket
# Schema source: tencentcloudstack/terraform-provider-tencentcloud

resource "tencentcloud_scf_function" "this" {
  name        = var.function_name
  description = var.description
  runtime     = var.runtime
  handler     = var.handler
  mem_size    = var.memory_size
  timeout     = var.timeout

  # Deploy from COS bucket
  cos_bucket_name   = var.cos_bucket
  cos_object_name   = var.cos_object_key
  cos_bucket_region = var.cos_bucket_region

  # Environment variables (TypeMap, not a block)
  environment = length(var.environment) > 0 ? var.environment : null

  # VPC config for DB access (flat attributes, not a block)
  vpc_id    = var.vpc_id != "" ? var.vpc_id : null
  subnet_id = var.subnet_id != "" ? var.subnet_id : null

  tags = merge(var.tags, { "app:module" = "scf-function" })
}

# HTTP trigger (Function URL) — replaces deprecated API Gateway product
# API Gateway was discontinued 2024-07-01; Function URL is the recommended replacement
resource "tencentcloud_scf_trigger_config" "http" {
  count = var.enable_http_trigger ? 1 : 0

  function_name = tencentcloud_scf_function.this.name
  trigger_name  = "http-trigger"
  type          = "http"
  enable        = "OPEN"
  qualifier     = "$DEFAULT"
}
