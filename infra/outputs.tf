output "cloudfront_domain_name" {
  description = "Public domain of the CloudFront distribution; the website is served at https://<this value>."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution, needed for cache invalidations after content changes."
  value       = aws_cloudfront_distribution.this.id
}

output "site_bucket_name" {
  description = "Name of the private S3 bucket holding the website content."
  value       = aws_s3_bucket.site.bucket
}

output "campaign_counter_table_name" {
  description = "Name of the DynamoDB table holding the campaign counter."
  value       = aws_dynamodb_table.campaign_counter.name
}

output "lambda_function_url" {
  description = "Direct Lambda function URL. Protected by AWS_IAM; a direct call must return 403 Forbidden."
  value       = aws_lambda_function_url.api.function_url
}
