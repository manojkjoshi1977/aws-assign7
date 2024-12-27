# # Create S3 Bucket
resource "aws_s3_bucket" "testwebpage1243" {
  bucket = "manoj2024-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
#uploading Index.html & error.html to S3 Bucket

resource "aws_s3_bucket_object" "testwebpage1243_object1" {
  bucket = aws_s3_bucket.testwebpage1243.id
  key    = "index.html"
  source = "./index.html"
  content_type = "text/html"

}                  
resource "aws_s3_bucket_object" "testwebpage1243_error" {
  bucket = aws_s3_bucket.testwebpage1243.id
  key    = "error.html"

  source = "./error.html"
  content_type = "text/html"
  
}                  
# configurting Index.html & error.html page in static website
resource "aws_s3_bucket_website_configuration" "testwebpage1243_configuration" {
  bucket = aws_s3_bucket.testwebpage1243.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket_object.testwebpage1243_object1, aws_s3_bucket_object.testwebpage1243_error ]
}
# Configuring permission for  Block Public Access Settings
resource "aws_s3_bucket_public_access_block" "testwebpage1243" {
  bucket = aws_s3_bucket.testwebpage1243.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# allowing Public access policy to static website
resource "aws_s3_bucket_policy" "testwebpage1243_policy" {
  bucket = aws_s3_bucket.testwebpage1243.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = ["s3:GetObject"],
        Resource = "arn:aws:s3:::manoj2024-test-bucket/*"
      }
    ]
  })
}
