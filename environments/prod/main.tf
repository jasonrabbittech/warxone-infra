# === VPC ===
module "vpc" {
  source = "../../modules/vpc"

  name              = "warxone-vpc"
  cidr_block        = "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
  zone              = "ap-hongkong-2"
  tags              = var.tags
}

# === Terraform state bucket ===
# NOTE: tfstate-1376958570 was manually created and is used as the COS backend.
# It should NOT be managed by Terraform (circular dependency).
# If needed: terraform import module.tfstate_bucket.tencentcloud_cos_bucket.this tfstate-1376958570

# === Game static assets bucket ===
# NOTE: warxone-1376958570 already exists. EdgeOne Pages handles serving.
# To import into Terraform later:
#   terraform import module.game_bucket.tencentcloud_cos_bucket.this warxone-1376958570

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
  zone          = "ap-hongkong-2"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.subnet_id
  db_password   = var.db_password
  tags          = var.tags
}

# === SCF Functions ===
# API Gateway product was discontinued 2024-07-01.
# Each SCF function gets an HTTP trigger (Function URL) for direct HTTP access.
locals {
  scf_env = {
    DB_HOST        = module.database.host
    DB_PORT        = tostring(module.database.port)
    DB_USER        = module.database.db_username
    DB_PASSWORD    = var.db_password
    DB_NAME        = "warxone_db"
    JWT_SECRET     = var.jwt_secret
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
    # Quiz functions
    quiz-start          = { desc = "Start a new quiz attempt", mem = 256, timeout = 15 }
    quiz-submit         = { desc = "Submit answer for current question", mem = 256, timeout = 15 }
    quiz-results        = { desc = "Get quiz attempt results", mem = 256, timeout = 15 }
    quiz-daily-status   = { desc = "Check daily quiz limit status", mem = 128, timeout = 10 }
    # Admin quiz management functions
    admin-quiz-list     = { desc = "List all quiz questions (admin)", mem = 256, timeout = 15 }
    admin-quiz-create   = { desc = "Create new quiz question (admin)", mem = 256, timeout = 15 }
    admin-quiz-update   = { desc = "Update quiz question (admin)", mem = 256, timeout = 15 }
    admin-quiz-delete   = { desc = "Delete quiz question (admin)", mem = 128, timeout = 10 }
  }
}

module "scf" {
  source = "../../modules/scf-function"
  for_each = local.scf_functions

  function_name = "warxone-${each.key}"
  description   = each.value.desc
  memory_size   = each.value.mem
  timeout       = each.value.timeout

  # Bootstrap mode: placeholder handler deployed inline via zip_file.
  # When actual code is ready, deploy via CI/CD (upload to COS + SCF API).
  # COS bucket is created but not used for deployment yet.
  environment = merge(local.scf_env, {
    GOOGLE_CLIENT_ID     = each.key == "auth-google" ? var.google_client_id : ""
    GOOGLE_CLIENT_SECRET = each.key == "auth-google" ? var.google_client_secret : ""
  })
  vpc_id   = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  tags     = var.tags

  enable_http_trigger = true
}
