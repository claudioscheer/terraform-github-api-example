#resource "aws_iam_role" "task_execution_role" {
#  name               = "github-api-task-execution-role"
#  assume_role_policy = data.aws_iam_policy_document.task_execution_role_assume_role_policy.json
#}
#
#data "aws_iam_policy_document" "task_execution_role_assume_role_policy" {
#  statement {
#    actions = ["sts:AssumeRole"]
#
#    principals {
#      type        = "Service"
#      identifiers = ["ecs-tasks.amazonaws.com"]
#    }
#  }
#}
#
#resource "aws_iam_role_policy_attachment" "task_execution_role_policy_attachment" {
#  role       = aws_iam_role.task_execution_role.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#}
#
#data "aws_iam_policy_document" "task_execution_role_policy" {
#  statement {
#    actions   = ["sqs:*"]
#    resources = [aws_sqs_queue.github_repos_to_fork.arn]
#  }
#}
#
#resource "aws_iam_role_policy" "task_execution_role_policy" {
#  name   = "github-api-task-execution-role-policy"
#  role   = aws_iam_role.task_execution_role.id
#  policy = data.aws_iam_policy_document.task_execution_role_policy.json
#}
