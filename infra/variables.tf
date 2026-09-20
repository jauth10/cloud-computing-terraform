variable "project_name" {
  description = "Project identifier, used as first part of every AWS resource name."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}$", var.project_name))
    error_message = "project_name must be lowercase alphanumeric with hyphens, 2-31 characters, starting with a letter."
  }
}

variable "environment" {
  description = "Deployment environment, used as second part of every AWS resource name."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{1,15}$", var.environment))
    error_message = "environment must be lowercase alphanumeric, 2-16 characters, starting with a letter."
  }
}

variable "aws_region" {
  description = "AWS region for all regional resources. CloudFront itself is global."
  type        = string
  default     = "eu-central-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.aws_region))
    error_message = "aws_region must look like an AWS region code, e.g. eu-central-1."
  }
}

variable "aws_profile" {
  description = "Name of the local AWS CLI / SSO profile used for authentication. Never put credentials here."
  type        = string
}

variable "log_retention_days" {
  description = "Retention of the Lambda CloudWatch log group in days. Bounded to avoid unbounded log storage cost."
  type        = number
  default     = 14

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90], var.log_retention_days)
    error_message = "log_retention_days must be one of the CloudWatch-supported values: 1, 3, 5, 7, 14, 30, 60, 90."
  }
}

variable "dynamodb_read_capacity" {
  description = "Provisioned read capacity units for the campaign counter table. Max 25 to stay within the always-free tier."
  type        = number
  default     = 25

  validation {
    condition     = var.dynamodb_read_capacity >= 1 && var.dynamodb_read_capacity <= 25
    error_message = "dynamodb_read_capacity must be between 1 and 25 (always-free tier limit)."
  }
}

variable "dynamodb_write_capacity" {
  description = "Provisioned write capacity units for the campaign counter table. Max 25 to stay within the always-free tier."
  type        = number
  default     = 25

  validation {
    condition     = var.dynamodb_write_capacity >= 1 && var.dynamodb_write_capacity <= 25
    error_message = "dynamodb_write_capacity must be between 1 and 25 (always-free tier limit)."
  }
}
