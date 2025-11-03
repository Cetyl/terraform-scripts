#############################################
# 1. ALB Access Logs Bucket
#############################################
resource "aws_s3_bucket" "alb_access_logs_test" {
  bucket = "prim-dev-alb-access-logs-test"

  tags = {
    Name        = "prim-dev-alb-access-logs-test"
    Environment = "test"
  }
}

resource "aws_s3_bucket_policy" "alb_access_logs_test_policy" {
  bucket = aws_s3_bucket.alb_access_logs_test.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowELBLogDelivery",
        Effect = "Allow",
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = "arn:aws:s3:::prim-dev-alb-access-logs-test/*"
      }
    ]
  })
}

#############################################
# 2. Download Bucket
#############################################
resource "aws_s3_bucket" "p8_download_test" {
  bucket = "prim-dev-p8-download-test"

  tags = {
    Name        = "prim-dev-p8-download-test"
    Environment = "test"
  }
}

resource "aws_s3_bucket_policy" "p8_download_test_policy" {
  bucket = aws_s3_bucket.p8_download_test.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowAccountAToListAndGetBucketLocation",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::677276089750:root"
        },
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads"
        ],
        Resource = "arn:aws:s3:::prim-dev-p8-download-test"
      },
      {
        Sid = "AllowAccountAToPutObjects",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::677276089750:root"
        },
        Action = [
          "s3:PutObject",
          "s3:AbortMultipartUpload"
        ],
        Resource = "arn:aws:s3:::prim-dev-p8-download-test/*"
      }
    ]
  })
}

#############################################
# 3. Upload Bucket
#############################################
resource "aws_s3_bucket" "p8_upload_test" {
  bucket = "prim-dev-p8-upload-test"

  tags = {
    Name        = "prim-dev-p8-upload-test"
    Environment = "test"
  }
}

resource "aws_s3_bucket_policy" "p8_upload_test_policy" {
  bucket = aws_s3_bucket.p8_upload_test.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowAccountAToListAndGetBucketLocation",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::677276089750:root"
        },
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads"
        ],
        Resource = "arn:aws:s3:::prim-dev-p8-upload-test"
      },
      {
        Sid = "AllowAccountAToPutObjects",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::677276089750:root"
        },
        Action = [
          "s3:PutObject",
          "s3:AbortMultipartUpload"
        ],
        Resource = "arn:aws:s3:::prim-dev-p8-upload-test/*"
      }
    ]
  })
}

#############################################
# 4. Terraform State File Bucket
#############################################
resource "aws_s3_bucket" "tf_statefile_test" {
  bucket = "prim-dev-tf-statefile-test"

  tags = {
    Name        = "prim-dev-tf-statefile-test"
    Environment = "test"
  }
}

# (optional) create folders like compute/, containers/, etc. as empty objects
resource "aws_s3_object" "tf_statefile_test_folders" {
  for_each = toset(["compute/", "containers/", "database/", "network/"])
  bucket   = aws_s3_bucket.tf_statefile_test.id
  key      = each.key
}
