terraform {
  required_version = "~> 1.8"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

locals {
  from       = format("%s/%s:%s", var.base_image.registry, var.base_image.name, var.base_image.tag)
  build_from = try(format("%s/%s:%s", var.build_stage.registry, var.build_stage.name, var.build_stage.tag), null)
  build_path = var.build_stage != null ? var.build_stage.path : null

  template_map = {
    build_from = local.build_from
    build_path = local.build_path
    from       = local.from
    path       = var.path
    handler    = var.handler
  }
}

resource "local_file" "Dockerfile" {
  content  = templatefile("${path.cwd}/${var.build.dockerfile}.tftpl", local.template_map)
  filename = "${path.cwd}/${var.build.dockerfile}"
}

locals {
  build_args = {
    from    = local.from
    handler = var.handler
    path    = var.path
  }

  build = {
    args       = merge(local.build_args, var.build.args)
    context    = var.build.context
    dockerfile = local_file.Dockerfile.filename
  }
}

resource "docker_image" "lambda" {
  name = var.name

  build {
    build_args = local.build.args
    tag        = [for i in setproduct([var.name], var.tags) : join(":", i)]
    context    = local.build.context
    platform   = var.platform
  }

  force_remove = var.force_remove
  keep_locally = var.keep_locally
  platform     = var.platform
}

resource "docker_registry_image" "lambda" {
  name          = docker_image.lambda.name
  keep_remotely = true
}
