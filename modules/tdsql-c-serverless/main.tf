# TDSQL-C Serverless cluster
# Uses cynosdb (TDSQL-C) resources
# Schema source: tencentcloudstack/terraform-provider-tencentcloud

resource "tencentcloud_cynosdb_cluster" "this" {
  available_zone = var.zone
  vpc_id         = var.vpc_id
  subnet_id      = var.subnet_id
  db_type        = "MYSQL"
  db_version     = var.engine_version
  db_mode        = "SERVERLESS"
  cluster_name   = var.instance_name
  password       = var.db_password
  port           = 3306

  # Serverless spec: auto-scale between min/max CCU
  min_cpu       = 0.25
  max_cpu       = 2
  storage_limit = 1000 # MB, auto-scale

  force_delete = true

  tags = merge(var.tags, { Module = "tdsql-c-serverless" })
}

# Create the application database
resource "tencentcloud_cynosdb_cluster_databases" "app_db" {
  cluster_id    = tencentcloud_cynosdb_cluster.this.id
  db_name       = "warxone_db"
  character_set = "utf8mb4"
  collate_rule  = "utf8mb4_general_ci"

  user_host_privileges {
    db_user_name = "root"
    db_host      = "%"
    db_privilege = "READ_WRITE"
  }
}

# Application database account
resource "tencentcloud_cynosdb_account" "app" {
  cluster_id        = tencentcloud_cynosdb_cluster.this.id
  account_name      = var.db_username
  account_password  = var.db_password
  host              = "%"
  description       = "Application user for WarXOne"

  depends_on = [tencentcloud_cynosdb_cluster_databases.app_db]
}

# Grant privileges to app user
resource "tencentcloud_cynosdb_account_privileges" "app" {
  cluster_id   = tencentcloud_cynosdb_cluster.this.id
  account_name = tencentcloud_cynosdb_account.app.account_name
  host         = "%"

  global_privileges = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "ALTER", "INDEX"]

  database_privileges {
    db          = "warxone_db"
    privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "ALTER", "INDEX"]
  }
}
