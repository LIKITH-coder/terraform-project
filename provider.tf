locals {
  region = "ap-south-1"
  access = "AKIA3NF2V25AY4CKDPND"
  secret = "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" 
}
 
provider "aws" {
  region = local.region
  access_key = local.access
  secret_key = local.secret
}
