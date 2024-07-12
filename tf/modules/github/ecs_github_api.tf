#resource "aws_ecs_cluster" "github_api" {
#  name = "github-api-cluster"
#}
#
#resource "aws_cloudwatch_log_group" "github_api" {
#  name = "/ecs/service/github-api"
#}
#
#resource "aws_ecs_task_definition" "github_api" {
#  family                   = "github-api-task"
#  requires_compatibilities = ["FARGATE"]
#  network_mode             = "awsvpc"
#  cpu                      = "256"
#  memory                   = "512"
#  execution_role_arn       = aws_iam_role.task_execution_role.arn
#  task_role_arn            = aws_iam_role.task_execution_role.arn
#  container_definitions    = <<DEFINITION
#  [
#    {
#      "name": "github-api-task",
#      "image": "${aws_ecr_repository.github_api.repository_url}:${var.github_api_version}",
#      "essential": true,
#      "memory": 512,
#      "cpu": 256,
#      "networkMode": "awsvpc",
#      "taskRoleArn": "${aws_iam_role.task_execution_role.arn}",
#      "executionRoleArn": "${aws_iam_role.task_execution_role.arn}",
#      "logConfiguration": {
#        "logDriver": "awslogs",
#        "options": {
#          "awslogs-group": "${aws_cloudwatch_log_group.github_api.name}",
#          "awslogs-region": "us-east-1",
#          "awslogs-stream-prefix": "ecs"
#        }
#      },
#      "environment": [
#        {
#          "name": "GITHUB_API_VERSION",
#          "value": "${var.github_api_version}"
#        },
#        {
#          "name": "FORK_REPO_QUEUE_URL",
#          "value": "${aws_sqs_queue.github_repos_to_fork.id}"
#        }
#      ],
#      "portMappings": [
#        {
#          "containerPort": 3000,
#          "hostPort": 3000
#        }
#      ]
#    }
#  ]
#  DEFINITION
#}
#
#resource "aws_ecs_service" "github_api" {
#  name            = "github-api-service"
#  cluster         = aws_ecs_cluster.github_api.id
#  task_definition = aws_ecs_task_definition.github_api.arn
#  desired_count   = 1
#  launch_type     = "FARGATE"
#
#  network_configuration {
#    subnets          = [aws_default_subnet.default_a.id]
#    security_groups  = [aws_security_group.ecs_github_api.id]
#    assign_public_ip = true
#  }
#
#  load_balancer {
#    target_group_arn = aws_lb_target_group.github_api.arn
#    container_name   = aws_ecs_task_definition.github_api.family
#    container_port   = 3000
#  }
#
#  depends_on = [aws_lb_listener.github_api]
#}
