output "vpc_id" {
  description = "VPC ID"
  value       = tencentcloud_vpc.this.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = tencentcloud_subnet.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = tencentcloud_vpc.this.cidr_block
}
