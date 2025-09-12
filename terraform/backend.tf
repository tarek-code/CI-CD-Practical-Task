terraform {
  backend "s3" {
    bucket         = "konecta-ci-terraform-state"
    key            = "ci/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ci-terraform-locks"
    encrypt        = true
  }
}
