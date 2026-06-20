output "cluster_id" {
  description = "TDSQL-C cluster ID"
  value       = tencentcloud_cynosdb_cluster.this.id
}

output "host" {
  description = "TDSQL-C internal connection address"
  value       = tencentcloud_cynosdb_cluster.this.vip
}

output "port" {
  description = "TDSQL-C connection port"
  value       = tencentcloud_cynosdb_cluster.this.vport
}

output "db_username" {
  description = "Application database username"
  value       = var.db_username
}
