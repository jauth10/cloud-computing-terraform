terraform {
  backend "s3" {
    bucket       = "aquavita-tfstate-iu-cloud"
    key          = "infra/terraform.tfstate"
    region       = "eu-central-1"
    profile      = "iu-cloud"
    encrypt      = true
    use_lockfile = true
  }
}
