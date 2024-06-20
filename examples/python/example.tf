terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

variable "ecr_repository_name" {
  default     = "dx_lambda/python-hello"
  description = "The name of the ECR repository to publish container image."
  type        = string
}

variable "ecr_registry_id" {
  default     = "709143748493"
  description = "The registry ID (AWS Region) of the ECR repository to publish container image."
  type        = string
}

resource "aws_ecr_repository" "lambda" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_authorization_token" "lambda" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address  = data.aws_ecr_authorization_token.lambda.proxy_endpoint
    username = data.aws_ecr_authorization_token.lambda.user_name
    password = data.aws_ecr_authorization_token.lambda.password
  }
}

module "docker" {
  source = "../.."

  name    = aws_ecr_repository.lambda.repository_url
  handler = "lambda.lambda_handler"
  tags    = ["latest", "1.0.6", "1.0", "1"]
  path    = "./src/"

  base_image = {
    name = "lambda/python"
  }
}

output "registry_image_name" {
  value = module.docker.registry_image_name
}

