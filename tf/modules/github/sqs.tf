resource "aws_sqs_queue" "github_repos_to_fork" {
  name = "github-repos-to-fork"
  visibility_timeout_seconds = 120
}
