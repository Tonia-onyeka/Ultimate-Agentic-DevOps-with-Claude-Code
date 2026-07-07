# S3 Backend for Terraform State
#
# To use a remote S3 backend for storing Terraform state:
#
# 1. First run: terraform init (without this backend configuration)
# 2. This will create resources with local state
# 3. Manually create an S3 bucket for the Terraform state:
#    aws s3api create-bucket \
#      --bucket terraform-state-${ACCOUNT_ID}-${REGION} \
#      --region eu-north-1 \
#      --create-bucket-configuration LocationConstraint=eu-north-1
#
# 4. Enable versioning on the state bucket:
#    aws s3api put-bucket-versioning \
#      --bucket terraform-state-${ACCOUNT_ID}-${REGION} \
#      --versioning-configuration Status=Enabled
#
# 5. Uncomment the backend block below
# 6. Run: terraform init -migrate-state (this will migrate local state to S3)
#
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-533267262133-eu-north-1"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "eu-north-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
