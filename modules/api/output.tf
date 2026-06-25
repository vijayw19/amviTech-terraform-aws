output "api_id" { value = aws_apigatewayv2_api.this.id }
output "api_arn" { value = aws_apigatewayv2_api.this.arn }
output "api_endpoint" { value = aws_apigatewayv2_api.this.api_endpoint }

output "stage_invoke_url" {
  description = "HTTP API base URL (for $default stage it's api_endpoint)."
  value       = aws_apigatewayv2_api.this.api_endpoint
}
