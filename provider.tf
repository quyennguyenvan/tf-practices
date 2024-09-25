//init the terraform config
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
}

provider "aws" {
  region  = "us-west-2" # switch other ap-southeast-1 or
  profile = "vti"
}
provider "random" {}
