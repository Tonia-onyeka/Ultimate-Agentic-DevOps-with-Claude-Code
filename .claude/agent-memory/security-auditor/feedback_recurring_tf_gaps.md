---
name: feedback-recurring-tf-gaps
description: Baseline set of Terraform security checklist items this project's authors tend to skip — check these first in future audits
metadata:
  type: feedback
---

For minimal S3+CloudFront static-site Terraform stacks like this one, the checklist items
most often missed (based on the [[project_portfolio_site_infra]] audit) are: SSE encryption
config, CloudFront response-headers policy for security headers, access logging (both S3 and
CloudFront), an enabled remote backend, and `.gitignore` coverage for `*.tfstate`/`*.tfvars`.

**Why**: these are all "extra resource blocks" beyond the minimum needed to get a working
site live, so they get skipped even when the core security posture (public access block, OAC,
HTTPS redirect, scoped bucket policy) is done correctly.

**How to apply**: When auditing a small static-site Terraform stack, always explicitly check
for these five items even if the core resources look secure at a glance — don't assume "looks
mostly right" means these are covered too.
