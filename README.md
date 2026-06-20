# WarXone Infrastructure

Terraform infrastructure for the WarXone game on Tencent Cloud.

## Structure

```
├── modules/
│   └── cos-static-site/    # Reusable COS bucket module
├── environments/
│   └── prod/               # Production environment
└── .github/workflows/      # CI/CD (terraform plan/apply)
```

## Prerequisites

- Tencent Cloud sub-account with SecretId/SecretKey
- GitHub Secrets: `TENCENTCLOUD_SECRET_ID`, `TENCENTCLOUD_SECRET_KEY`
- COS bucket for tfstate backend (created manually: `tfstate-1376958570`)

## Usage

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

## Related Repos

- **Application**: https://github.com/jasonrabbittech/warxone-game
