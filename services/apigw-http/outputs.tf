output "api_endpoints" {
  value = { for k, v in module.http_apis : k => v.api_endpoint }
}
