---
name: portfolio-site-cost-analysis
description: AWS cost optimization analysis for static portfolio site (S3 + CloudFront)
metadata:
  type: project
---

## Infrastructure Overview
- **S3 Bucket:** pravinmishradmi-site-production (private, versioned)
- **CloudFront Distribution:** E3V6O6MRE2E21P (PriceClass_200)
- **Region:** eu-north-1
- **Use Case:** Static HTML/CSS portfolio site (~50MB typical size)

## Current Monthly Cost Estimate
- S3 Storage (Standard): $0.10-0.50
- S3 Versioning overhead: $0.05-0.20
- CloudFront data transfer (PriceClass_200): $0.50-5.00
- CloudFront requests: $0.01-0.10
- **Total: $0.66-5.80/month**

## Key Optimization Opportunities Identified

### Quick Wins (< 1 hour to implement)
1. **Disable S3 Versioning** — Unnecessary for static portfolio site
   - Impact: Save $0.05-0.20/month (~$0.60-2.40/year)
   - Why: Every file version is stored; no need for version history on portfolio site
   
2. **Downgrade CloudFront Price Class** — PriceClass_100 sufficient for most single-portfolio audiences
   - Impact: Save ~$0.17-1.67/month (~$2.04-20/year) [33% reduction]
   - Why: PriceClass_100 covers US + Europe. PriceClass_200 adds Japan, Asia, Australia which may be unnecessary

### Nice-to-Have Optimizations
- S3 lifecycle rules for future state bucket versioning (when backend enabled)
- Consider CloudFront origin request policy evaluation (current CORS-S3Origin is appropriate)

## No Action Needed
- S3 storage class: Standard is correct for frequently accessed content
- CloudFront compression: Already enabled (good)
- CloudFront caching TTL: CachingOptimized policy is appropriate
- Origin Shield: Not cost-effective for this traffic volume
- Reserved capacity: Not applicable for small static site
