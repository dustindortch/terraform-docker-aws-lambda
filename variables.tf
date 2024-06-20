variable "base_image" {
  description = "The base image to pull from the container registry.  List available: https://gallery.ecr.aws/lambda/"
  type = object({
    name     = string
    registry = optional(string, "public.ecr.aws")
    tag      = optional(string, "latest")
  })
}

variable "build_stage" {
  default     = null
  description = "Dockerfile directives for build stage of multi-stage build."
  type = object({
    name     = optional(string)
    registry = optional(string)
    path     = optional(string)
    tag      = optional(string)
  })
}

# variable "ecr_repository_name" {
#   description = "The name of the ECR repository to publish container image."
#   type        = string
# }

variable "force_remove" {
  default     = true
  description = "If true, then the image is removed forcibly when the resource is destroyed."
  type        = bool
}

variable "keep_locally" {
  default     = false
  description = "If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
}

variable "name" {
  description = "The name of the target container image."
  type        = string
}

variable "tags" {
  default     = ["latest"]
  description = "The tags of the target container image."
  type        = list(string)
}

variable "build" {
  default     = {}
  description = "The build configuration for the Docker image."
  type = object({
    args       = optional(map(string), {})
    context    = optional(string, ".")
    dockerfile = optional(string, "Dockerfile")
  })
}

variable "path" {
  description = "The path to application code to copy into container."
  type        = string
}

variable "handler" {
  description = "The handler function to invoke the Lambda function."
  type        = string
}

variable "platform" {
  default     = "linux/amd64"
  description = "The platform to build the Docker image."
  type        = string

  validation {
    condition     = contains(["linux/amd64", "linux/arm64)"], var.platform)
    error_message = "The platform must be either linux/amd64 or linux/arm64."
  }
}

variable "triggers" {
  default     = {}
  description = "The triggers to pull/rebuild the Docker image."
  type        = map(string)
}
