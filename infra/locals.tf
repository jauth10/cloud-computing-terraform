locals {
  name_prefix = "${var.project_name}-${var.environment}" # e.g. aquavita-prod

  table_name     = "${local.name_prefix}-campaign-counter"
  function_name  = "${local.name_prefix}-api"
  log_group_name = "/aws/lambda/${local.function_name}"
}
