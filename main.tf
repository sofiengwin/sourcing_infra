terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region = "us-east-1"
}

resource "aws_lambda_function" "test_lambda" {
  s3_bucket = var.bucket_name
  s3_key = var.s3_key
  function_name = "api_sourcer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "bootstrap"

  runtime = "go1.x"

  environment {
    variables = {
      BAR = "BAR"
      FOO = "FOO"
      SUPABASE_KEY = var.SUPABASE_KEY
      SUPABASE_URL = var.SUPABASE_URL
      X_RapidAPI_KEY = var.X_RapidAPI_KEY
    }
  }
}

resource "aws_lambda_function_url" "test_latest" {
  function_name      = aws_lambda_function.test_lambda.function_name
  authorization_type = "NONE"
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda_logging" {
   statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

# resource "aws_iam_policy" "lambda_logging" {
#   name        = "lambda_logging"
#   description = "IAM policy for logging from a lambda"
#   policy      = data.aws_iam_policy_document.lambda_logging.json
# }

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_s3_bucket" "exam_bot_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}