output "lambda_name" { value = aws_lambda_function.this.function_name }
output "lambda_arn"  { value = aws_lambda_function.this.arn }
output "invoke_arn"  { value = aws_lambda_function.this.invoke_arn }

output "function_url" {
  value       = try(aws_lambda_function_url.this[0].function_url, null)
  description = "Lambda Function URL (if enabled)"
}
