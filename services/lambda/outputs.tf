output "lambda_arns" {
  value = { for k, v in module.lambdas : k => v.lambda_arn }
}

output "lambda_invoke_arns" {
  value = { for k, v in module.lambdas : k => v.invoke_arn }
}

output "lambda_function_urls" {
  value = { for k, v in module.lambdas : k => v.function_url }
}
