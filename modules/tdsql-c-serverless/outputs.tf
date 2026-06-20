output "cluster_id" {
  description = "TDSQL-C cluster ID"
  value       = tencentcloud_cynosdb_cluster.this.id
}

output "host" {
  description = "TDSQL-C internal connection address (VIP from RW group)"
  value       = tencentcloud_cynosdb_cluster.this.rw_group_addr[0].ip
}

output "port" {
  description = "TDSQL-C connection port"
  value       = tencentcloud_cynosdb_cluster.this.port
}

output "db_username" {
  description = "Application database username"
  value       = var.db_username
}
