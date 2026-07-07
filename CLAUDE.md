# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions.

## Architecture

### Static Site
- **index.html** — Main portfolio page with profile, projects, and contact sections
- **style.css** — All styling (responsive, mobile-friendly)
- **privacy.html** & **terms.html** — Legal pages
- **images/** — Static assets (logos, profile pictures, etc.)
- Pure HTML5 and CSS3. No JavaScript. No build step. No framework.

### Infrastructure & Deployment
- **terraform/** — AWS infrastructure code (S3 bucket, CloudFront distribution)
  - Managed via custom Claude Code skills: `/scaffold-terraform`, `/tf-plan`, `/tf-apply`
  - Currently deployed to: S3 bucket `pravinmishradmi-site-production`, CloudFront distribution ID `E3V6O6MRE2E21P`
  - Region: `eu-north-1`
- **.github/workflows/deploy.yml** — GitHub Actions workflow
  - Triggers on push to `main` branch
  - Uses AWS OIDC for authentication (no stored credentials)
  - Syncs site files to S3, invalidates CloudFront cache


  ## Commands
  ```Bash
  # terraform
  - `terraform init`    # Initialize the Terraform project
  - `terraform plan`    # Preview the changes Terraform will make
  - `terraform apply`   # Apply the changes

  ---

###  Conventions
  - All infrastructure changes go through Terraform — never modify AWS resources manually
  - No JavaScript in this project
  - CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety
  - Never put secrets in this file. No API keys, passwords, or AWS credentials.


### Custom Skills
These Claude Code skills automate the deployment workflow:
- `/scaffold-terraform [region] [project-name]` — Generate Terraform config for S3 + CloudFront
- `/tf-plan` — Run `terraform plan` and analyze changes
- `/tf-apply` — Run `terraform apply` to create/update infrastructure
- `/deploy` — Sync site to S3 and invalidate CloudFront cache

## Ownership Proof (DMI Requirement)

Before deployment, students **must** edit the footer in **index.html** to add their ownership proof:

```html
<!-- Add this line in the footer (replace with actual details) -->
<p><strong>Deployed by:</strong> DMI Cohort 2 | [Your Name] | Group [#] | Week 1 | [Date]</p>
```

This proof must be visible in browser screenshots submitted for the assignment.

## Common Development Tasks

### View the site locally
```bash
# Open in browser (no build step needed for static HTML)
start index.html  # Windows
open index.html   # macOS
```

### Edit the portfolio content
- Update **index.html** for content changes (profile, projects, contact info)
- Update **style.css** for styling changes
- Add images to **images/** directory and reference them in HTML

### Deploy changes
**Option 1: Automatic (Recommended)**
- Commit and push changes to `main` branch
- GitHub Actions workflow runs automatically, syncs to S3, invalidates CloudFront

**Option 2: Manual via Claude Code**
```bash
/tf-plan       # Review infrastructure changes
/tf-apply      # Apply infrastructure changes (if needed)
/deploy        # Sync site files to S3 and invalidate cache
```

### Set up new AWS infrastructure
```bash
/scaffold-terraform eu-north-1 portfolio-site
/tf-plan
/tf-apply
```

## Key Configuration

### GitHub Actions (CI/CD)
- **Workflow file:** `.github/workflows/deploy.yml`
- **Trigger:** Pushes to `main` branch
- **Authentication:** AWS OIDC (role: `arn:aws:iam::533267262133:role/github-actions-deploy`)
- **Actions:**
  1. Sync to S3 (excludes: .git, .github, .claude, terraform, .md files)
  2. Invalidate CloudFront cache for all paths (`/*`)

### AWS Resources
- **S3 Bucket:** `pravinmishradmi-site-production` (private, no public access)
- **CloudFront Distribution:** `E3V6O6MRE2E21P` (serves index.html as root, redirects HTTP → HTTPS)
- **Region:** `eu-north-1`

### Terraform Backend
The Terraform backend is configured to use S3 state storage. See `terraform/backend.tf` for setup instructions (requires manual state bucket creation on first run).

## Important Notes

1. **No build step required** — This is a static site; HTML/CSS files are deployed as-is.
2. **Automatic deployment on push** — Any push to `main` triggers GitHub Actions; no manual CLI commands needed for typical workflows.
3. **AWS OIDC authentication** — No AWS credentials are stored in GitHub; uses OIDC tokens for secure authentication.
4. **Ownership proof is mandatory** — DMI rule: footer must show who deployed the site and when.
5. **CloudFront caching** — Cache is invalidated on every deployment to ensure fresh content.

## Troubleshooting

### Site not updating after push
- Check GitHub Actions workflow status (`.github/workflows/deploy.yml`)
- Wait 1-2 minutes for CloudFront cache invalidation to complete
- Clear browser cache or open in incognito window

### Terraform errors
- Ensure AWS credentials are configured (use AWS OIDC in CI or `aws configure` locally)
- Check `terraform/` directory exists and is initialized: `cd terraform && terraform init`
- Review `.github/workflows/deploy.yml` for current AWS region and resource IDs

### Deployment fails with permission errors
- Verify GitHub Actions role has permissions for S3 and CloudFront
- Check role ARN in `.github/workflows/deploy.yml` matches current AWS account
