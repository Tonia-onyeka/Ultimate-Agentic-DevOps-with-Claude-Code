---
name: project-portfolio-site-infra
description: Architecture and known security gaps in the pravinmishradmi portfolio site AWS infra (S3 + CloudFront via Terraform)
metadata:
  type: project
---

This repo deploys a static portfolio site to S3 (`pravinmishradmi-site-production`) behind
CloudFront (`E3V6O6MRE2E21P`) in `eu-north-1`, account `533267262133`, provisioned by
`terraform/main.tf`. Deployment is via `.github/workflows/deploy.yml` on push to `main`
using AWS OIDC role `arn:aws:iam::533267262133:role/github-actions-deploy`.

**Important gap**: the GitHub Actions OIDC IAM role (`github-actions-deploy`) is NOT defined
anywhere in `terraform/` — it's only referenced by ARN in the workflow file. This means its
trust policy (repo/branch scoping) and permission policy (least privilege) cannot be verified
from Terraform code and were presumably created manually, which also violates this project's
own CLAUDE.md rule "all infrastructure changes go through Terraform — never modify AWS
resources manually."

As of the 2026-07-08 audit, `terraform/main.tf` correctly implements: S3 public access block
(all four flags true), CloudFront Origin Access Control (not legacy OAI) with a bucket policy
scoped via `AWS:SourceArn` condition to the specific distribution, and
`viewer_protocol_policy = "redirect-to-https"`.

Known recurring gaps to re-check on future audits (see [[feedback_recurring_tf_gaps]]):
- No `aws_s3_bucket_server_side_encryption_configuration` (no encryption at rest)
- No CloudFront `aws_cloudfront_response_headers_policy` (no CSP/X-Frame-Options/HSTS)
- No S3 access logging or CloudFront `logging_config`
- `terraform/backend.tf` keeps the S3 remote backend commented out (local state in use)
- Root `.gitignore` only excludes `.terraform` — does NOT exclude `*.tfstate` or `*.tfvars`,
  so a local `terraform apply` risks committing state (which can contain sensitive data)
- `viewer_certificate` uses `cloudfront_default_certificate = true` even though a
  `domain_name` variable exists and is unused — TLS min version can't be pinned to
  TLSv1.2_2021 without a custom domain + ACM cert
- No `aws_s3_bucket_ownership_controls` (BucketOwnerEnforced) to fully disable ACLs

**How to apply**: When re-auditing this repo, check whether these specific gaps have been
fixed rather than re-deriving them from scratch, and flag the missing OIDC-role-in-Terraform
issue every time since it's a standing violation of the project's own IaC-only policy.
