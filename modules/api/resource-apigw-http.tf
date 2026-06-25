##############################################
# HTTP API
##############################################
resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"

  description = var.description

  cors_configuration {
    allow_origins = var.enable_cors ? var.cors_allow_origins : null
    allow_methods = var.enable_cors ? var.cors_allow_methods : null
    allow_headers = var.enable_cors ? var.cors_allow_headers : null
    expose_headers = var.enable_cors ? var.cors_expose_headers : null
    max_age       = var.enable_cors ? var.cors_max_age : null
    allow_credentials = var.enable_cors ? var.cors_allow_credentials : null
  }

  tags = var.tags
}

##############################################
# Integration (Lambda proxy)
##############################################
resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_invoke_arn
  payload_format_version = "2.0"
  timeout_milliseconds   = var.integration_timeout_ms
}

##############################################
# Route
##############################################
resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = var.route_key # e.g., "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

##############################################
# Stage
##############################################
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = var.auto_deploy

  tags = var.tags
}

##############################################
# Lambda permission so API Gateway can invoke it
##############################################
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowInvokeFromHttpApi-${var.stage_name}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}
