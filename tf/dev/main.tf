provider "aws" {
  region = "us-east-1"
}

module "github" {
  source = "../modules/github"

  github_api_version = "v0.0.2"
}
