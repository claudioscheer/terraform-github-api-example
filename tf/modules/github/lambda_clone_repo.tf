resource "aws_lambda_function" "clone_github_repo" {
  function_name = "clone-github-repo"
  filename      = "${path.root}/../../microservices/tmp/clone-repo.zip"
  handler       = "lambda.handler"
  runtime       = "python3.11"
  memory_size   = 512
  ephemeral_storage {
    size = 512
  }
  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.github_repos_forked.bucket
    }
  }
  role = aws_iam_role.github_clone_repo.arn
}

resource "aws_iam_role" "github_clone_repo" {
  name = "github-clone-repo-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_clone_basic" {
  role       = aws_iam_role.github_clone_repo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "github_clone_sqs" {
  role       = aws_iam_role.github_clone_repo.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy" "github_clone_repo_permissions" {
  name = "github-clone-repo-policy"
  role = aws_iam_role.github_clone_repo.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = ["s3:PutObject", "s3:GetObject"],
      Effect = "Allow",
      Resource = [
        aws_s3_bucket.github_repos_forked.arn,
        "${aws_s3_bucket.github_repos_forked.arn}/*"
      ]
    }]
  })
}
