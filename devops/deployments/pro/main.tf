provider "aws" {
  version = "~> 2.33"
  region = "${var.region}"
}

module "entities-lambda-endpoint" {
  source = "./modules/entities-lambda-endpoint"

  region              = "${var.region}"
  account-id          = "${var.accountid}"
  environment         = "${var.env}"
  api-name            = "${var.app}-${var.env}-api"
  lambda-name         = "${var.app}-${var.env}-lambda"
  lambda-artifact     = "../../artifacts/${var.app}.zip"
  lambda-role         = "${var.app}-${var.env}-lambda-role"
  lambda-role-policy  = "${var.app}-${var.env}-lambda-role-policy"
  tables              = "${var.tables}"
}

output "url" {
  value       = module.entities-lambda-endpoint.invoke-url
}

terraform {
  backend "s3" {
    bucket         = "entity-service-pro-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "entity-service-pro-terraform-state-lock"
    encrypt        = true
  }
}
