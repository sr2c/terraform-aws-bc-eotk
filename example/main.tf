terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "bc_eotk" {
  source    = "./.."
  namespace = "eg"
  name      = "bc-eotk"
  instance_count = 1
}
