
# 1. Create the S3 bucket
resource "aws_s3_bucket" "portfolio" {
  bucket = "portn74947523j557"
}

# 2. Allow public website access
resource "aws_s3_bucket_public_access_block" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# 3. Enable static website hosting
resource "aws_s3_bucket_website_configuration" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# 4. Allow visitors to read website files
resource "aws_s3_bucket_policy" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.portfolio.arn}/*"
    }]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.portfolio
  ]
}

# 5. Upload index.html from the checked-out GitHub repository
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.portfolio.id
  key          = "index.html"
  source       = "${path.module}/portfolio/index.html"
  etag         = filemd5("${path.module}/portfolio/index.html")
  content_type = "text/html"
}

# 6. Upload the image from the checked-out GitHub repository
resource "aws_s3_object" "image" {
  bucket       = aws_s3_bucket.portfolio.id
  key          = "ankita.png"
  source       = "${path.module}/portfolio/ankita.png"
  etag         = filemd5("${path.module}/portfolio/ankita.png")
  content_type = "image/png"
}

# 7. Display outputs
output "portfolio_bucket_arn" {
  value = aws_s3_bucket.portfolio.arn
}

output "portfolio_website_url" {
  value = "http://${aws_s3_bucket_website_configuration.portfolio.website_endpoint}"
}

output "portfolio_image_url" {
  value = "https://${aws_s3_bucket.portfolio.bucket_regional_domain_name}/ankita.png"
}
