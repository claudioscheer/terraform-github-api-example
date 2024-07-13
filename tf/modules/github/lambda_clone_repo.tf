resource "aws_lambda_function" "clone_github_repo" {
  timeout          = 120
  function_name    = "clone-github-repo"
  filename         = "${path.root}/../../microservices/tmp/clone-repo.zip"
  handler          = "lambda.handler"
  runtime          = "python3.11"
  memory_size      = 512
  source_code_hash = filebase64sha256("${path.root}/../../microservices/tmp/clone-repo.zip")
  ephemeral_storage {
    size = 512
  }
  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.github_repos_forked.bucket
    }
  }
  role = aws_iam_role.github_clone_repo.arn
  layers = [
    "arn:aws:lambda:us-east-1:553035198032:layer:git-lambda2:8"
  ]
}

resource "aws_lambda_event_source_mapping" "github_clone_sqs_trigger" {
  event_source_arn = aws_sqs_queue.github_repos_to_fork.arn
  function_name    = aws_lambda_function.clone_github_repo.arn
  batch_size       = 1
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
