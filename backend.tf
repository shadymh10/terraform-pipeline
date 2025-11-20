terraform {
  backend "s3" {
    bucket       = "s3-production-pipeline1"
    key          = "eks/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

