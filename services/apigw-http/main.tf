module "http_apis" {
  source  = "../../modules/api/apigw-http"
  for_each = var.http_apis

  api_name     = each.value.api_name
  description  = lookup(each.value, "description", null)

  stage_name   = lookup(each.value, "stage_name", "$default")
  auto_deploy  = lookup(each.value, "auto_deploy", true)

  route_key            = each.value.route_key
  lambda_invoke_arn     = each.value.lambda_invoke_arn
  lambda_function_name  = each.value.lambda_function_name

  integration_timeout_ms = lookup(each.value, "integration_timeout_ms", 29000)

  enable_cors             = lookup(each.value, "enable_cors", false)
  cors_allow_origins      = lookup(each.value, "cors_allow_origins", ["*"])
  cors_allow_methods      = lookup(each.value, "cors_allow_methods", ["GET","POST","PUT","DELETE","OPTIONS"])
  cors_allow_headers      = lookup(each.value, "cors_allow_headers", ["*"])
  cors_expose_headers     = lookup(each.value, "cors_expose_headers", [])
  cors_max_age            = lookup(each.value, "cors_max_age", 0)
  cors_allow_credentials  = lookup(each.value, "cors_allow_credentials", false)

  tags = merge(var.common_tags, lookup(each.value, "tags", {}))
}
