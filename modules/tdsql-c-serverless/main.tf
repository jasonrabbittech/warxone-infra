# TDSQL-C Serverless cluster
# Uses cynosdb (TDSQL-C) resources, NOT mysql (TDSQL)
resource "tencentcloud_cynosdb_cluster" "this" {
  name             = var.instance_name
  db_type          = "MYSQL"
  db_version       = var.engine_version
  serverless_mode  = 1   # 1 = Serverless
  pay_mode         = var.pay_type
  zone             = var.zone
  vpc_id           = var.vpc_id
  subnet_id        = var.subnet_id

  # Serverless spec: min/max CU
  cynosdb_instance {
    instance_type  = "SERVERLESS"
    cpu            = 1
    mem_size       = 1    # 1 GB
    min_cpu        = 0.25 # 0.25 CCU minimum
    max_cpu        = 2    # 2 CCU max (auto-scale)
  }

  # Storage: auto-scaling, pay per GB
  storage_limit    = 1000 # MB, auto-scale

  tags = merge(var.tags, { Module = "tdsql-c-serverless" })
}

# Application database account
resource "tencentcloud_cynosdb_account" "app" {
  cluster_id   = tencentcloud_cynosdb_cluster.this.id
  account_name = var.db_username
  account_password = var.db_password
  description  = "Application user for WarXOne"
}

# Grant privileges to app user
resource "tencentcloud_cynosdb_account_privilege" "app" {
  cluster_id    = tencentcloud_cynosdb_cluster.this.id
  account_name  = tencentcloud_cynosdb_account.app.account_name
  global_privileges = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "ALTER", "INDEX"]
  db privileges {
    db_name       = "warxone_db"
    privileges    = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "ALTER", "INDEX"]
  }
}
