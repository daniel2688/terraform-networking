terraform {
  backend "s3" {
    bucket         = "backend-terraform-networking"
    key            = "resources-networking/dev/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}