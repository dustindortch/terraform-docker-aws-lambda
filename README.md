# terraform-docker-aws-lambda

Module that builds containers images for AWS Lambda functions.

## Usage

See examples.

## Exmaples

* Python - `examples/python` - Takes input Python file and builds container image with `lambda/python` base image
* .NET 6 - `examples/dotnet` - Takes input .NET 6 project and builds multi-stage container image using the `dotnet/sdk` build image and `lambda/dotnet` base image


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | ~> 3.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [docker_image.lambda](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image) | resource |
| [docker_registry_image.lambda](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/registry_image) | resource |
| [local_file.Dockerfile](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_image"></a> [base\_image](#input\_base\_image) | The base image to pull from the container registry.  List available: https://gallery.ecr.aws/lambda/ | <pre>object({<br>    name     = string<br>    registry = optional(string, "public.ecr.aws")<br>    tag      = optional(string, "latest")<br>  })</pre> | n/a | yes |
| <a name="input_build"></a> [build](#input\_build) | The build configuration for the Docker image. | <pre>object({<br>    args       = optional(map(string), {})<br>    context    = optional(string, ".")<br>    dockerfile = optional(string, "Dockerfile")<br>  })</pre> | `{}` | no |
| <a name="input_build_stage"></a> [build\_stage](#input\_build\_stage) | Dockerfile directives for build stage of multi-stage build. | <pre>object({<br>    name     = string<br>    registry = optional(string, "public.ecr.aws")<br>    path     = string<br>    tag      = optional(string, "latest")<br>  })</pre> | `null` | no |
| <a name="input_force_remove"></a> [force\_remove](#input\_force\_remove) | If true, then the image is removed forcibly when the resource is destroyed. | `bool` | `true` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The handler function to invoke the Lambda function. | `string` | n/a | yes |
| <a name="input_keep_locally"></a> [keep\_locally](#input\_keep\_locally) | If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the target container image. | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | The path to application code to copy into container. | `string` | n/a | yes |
| <a name="input_platform"></a> [platform](#input\_platform) | The platform to build the Docker image. | `string` | `"linux/amd64"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags of the target container image. | `list(string)` | <pre>[<br>  "latest"<br>]</pre> | no |
| <a name="input_triggers"></a> [triggers](#input\_triggers) | The triggers to pull/rebuild the Docker image. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry_image_name"></a> [registry\_image\_name](#output\_registry\_image\_name) | n/a |
<!-- END_TF_DOCS -->