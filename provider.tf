provider "aws" {
}




terraform {
  backend "s3" {
    bucket       = "portshb486t89"
    key          = "portfolio-s3/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
