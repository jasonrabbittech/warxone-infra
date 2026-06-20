# === VPC ===
module "vpc" {
  source = "../../modules/vpc"

  name           = "warxone-vpc"
  cidr_block     = "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
  zone           = "ap-hongkong-1"
  tags           = var.tags
}

# === Terraform state bucket ===
module "tfstate_bucket" {
  source = "../../modules/cos-static-site"

  bucket_name    = "tfstate-${var.app_id}"
  region         = var.region
  acl            = "private"
  enable_website = false
  tags           = var.tags
}

# === Game static assets bucket (fallback / backup for EdgeOne Pages) ===
module "game_bucket" {
  source = "../../modules/cos-static-site"

  bucket_name         = "${var.project_name}-${var.app_id}"
  region              = var.region
  acl                 = "public-read"
  enable_website      = true
  index_document      = "index.html"
  error_document      = "index.html"
  cors_allowed_origins = ["https://*.edgeoneapp.com", "https://*.myqcloud.com"]
  tags                = var.tags
}

# === SCF deployment packages bucket ===
module "scf_deploy_bucket" {
  source = "../../modules/cos-static-site"

  bucket_name    = "warxone-scf-deploy-${var.app_id}"
  region         = var.region
  acl            = "private"
  enable_website = false
  tags           = var.tags
}

# === Database (TDSQL-C Serverless) ===
module "database" {
  source = "../../modules/tdsql-c-serverless"

  instance_name = "warxone-db"
  zone          = "ap-hongkong-1"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.subnet_id
  db_password   = var.db_password
  tags          = var.tags
}

# === SCF Functions ===
locals {
  scf_env = {
    DB_HOST     = module.database.host
    DB_PORT     = tostring(module.database.port)
    DB_USER     = module.database.db_username
    DB_PASSWORD = var.db_password
    DB_NAME     = "warxone_db"
    JWT_SECRET  = var.jwt_secret
    ALLOWED_ORIGIN = "https://warxone-game-dpzpjjtty6i7.edgeone.dev"
  }

  scf_functions = {
    auth-register = { desc = "Email+password registration", mem = 256, timeout = 15 }
    auth-login    = { desc = "Email+password login", mem = 256, timeout = 15 }
    auth-google   = { desc = "Google SSO callback", mem = 256, timeout = 15 }
    auth-refresh  = { desc = "Refresh JWT tokens", mem = 128, timeout = 10 }
    auth-logout   = { desc = "Logout (revoke refresh token)", mem = 128, timeout = 10 }
    game-save     = { desc = "Save game state to DB", mem = 256, timeout = 10 }
    game-load     = { desc = "Load game state from DB", mem = 256, timeout = 10 }
    game-delete   = { desc = "Delete game save", mem = 128, timeout = 10 }
  }
}

module "scf" {
  source = "../../modules/scf-function"
  for_each = local.scf_functions

  function_name    = "warxone-${each.key}"
  description      = each.value.desc
  memory_size      = each.value.mem
  timeout          = each.value.timeout
  cos_bucket       = module.scf_deploy_bucket.bucket_name
  cos_object_key   = "functions/${each.key}.zip"
  cos_bucket_region = var.region
  environment      = merge(local.scf_env, {
    # Google-specific env vars only for auth-google
    GOOGLE_CLIENT_ID     = each.key == "auth-google" ? var.google_client_id : ""
    GOOGLE_CLIENT_SECRET = each.key == "auth-google" ? var.google_client_secret : ""
  })
  vpc_id   = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  tags     = var.tags
}

# === API Gateway ===
module "api_gateway" {
  source = "../../modules/api-gateway"

  service_name = "warxone-api"
  tags         = var.tags

  routes = [
    { path = "/api/auth/register", method = "POST", function_name = "warxone-auth-register" },
    { path = "/api/auth/login",    method = "POST", function_name = "warxone-auth-login" },
    { path = "/api/auth/google",   method = "POST", function_name = "warxone-auth-google" },
    { path = "/api/auth/refresh",  method = "POST", function_name = "warxone-auth-refresh" },
    { path = "/api/auth/logout",   method = "POST", function_name = "warxone-auth-logout" },
    { path = "/api/game/save",     method = "GET",    function_name = "warxone-game-load" },
    { path = "/api/game/save",     method = "PUT",    function_name = "warxone-game-save" },
    { path = "/api/game/save",     method = "DELETE", function_name = "warxone-game-delete" },
  ]
}
