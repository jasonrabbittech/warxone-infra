resource "tencentcloud_scf_function" "this" {
  function_name = var.function_name
  description   = var.description
  runtime       = var.runtime
  handler       = var.handler
  memory_size   = var.memory_size
  timeout       = var.timeout

  # Deploy from COS bucket
  cos_bucket_name = var.cos_bucket
  cos_object_key  = var.cos_object_key

  # Environment variables
  dynamic "environment" {
    for_each = length(var.environment) > 0 ? [1] : []
    content {
      variables = var.environment
    }
  }

  # VPC config for DB access
  dynamic "vpc_config" {
    for_each = var.vpc_id != "" ? [1] : []
    content {
      vpc_id    = var.vpc_id
      subnet_id = var.subnet_id
    }
  }

  tags = merge(var.tags, { Module = "scf-function" })
}
