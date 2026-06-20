resource "tencentcloud_vpc" "this" {
  name       = var.name
  cidr_block = var.cidr_block
  tags       = merge(var.tags, { Module = "vpc" })
}

resource "tencentcloud_subnet" "this" {
  name       = "${var.name}-subnet"
  vpc_id     = tencentcloud_vpc.this.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.zone
  tags       = merge(var.tags, { Module = "vpc" })
}
