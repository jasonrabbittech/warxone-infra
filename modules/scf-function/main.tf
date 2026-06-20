# SCF Function deployed from COS bucket
# Schema source: tencentcloudstack/terraform-provider-tencentcloud

resource "tencentcloud_scf_function" "this" {
  function_name = var.function_name
  description   = var.description
  runtime       = var.runtime
  handler       = var.handler
  mem_size      = var.memory_size
  timeout       = var.timeout

  # Deploy from COS bucket
  cos_bucket_name = var.cos_bucket
  cos_object_name = var.cos_object_key
  cos_bucket_region = var.cos_bucket_region

  # Environment variables (TypeMap, not a block)
  environment = length(var.environment) > 0 ? var.environment : null

  # VPC config for DB access (flat attributes, not a block)
  vpc_id    = var.vpc_id != "" ? var.vpc_id : null
  subnet_id = var.subnet_id != "" ? var.subnet_id : null

  tags = merge(var.tags, { Module = "scf-function" })
}
