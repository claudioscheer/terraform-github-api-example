resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default_a" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_b" {
  availability_zone = "us-east-1b"
}

#resource "aws_security_group" "load_balancer" {
#  name = "load-balancer"
#
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
#resource "aws_security_group" "ecs_github_api" {
#  name = "ecs-github-api"
#
#  ingress {
#    from_port       = 3000
#    to_port         = 3000
#    protocol        = "tcp"
#    security_groups = [aws_security_group.load_balancer.id]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
#resource "aws_lb" "github_api" {
#  name = "github-api"
#
#  load_balancer_type = "application"
#  subnets            = [aws_default_subnet.default_a.id, aws_default_subnet.default_b.id]
#  security_groups    = [aws_security_group.load_balancer.id]
#}
#
#resource "aws_lb_target_group" "github_api" {
#  port        = 3000
#  protocol    = "HTTP"
#  target_type = "ip"
#  vpc_id      = aws_default_vpc.default.id
#
#  health_check {
#    enabled             = true
#    path                = "/_health"
#    protocol            = "HTTP"
#    matcher             = 200
#    interval            = 5
#    timeout             = 2
#    healthy_threshold   = 2
#    unhealthy_threshold = 2
#  }
#}
#
#resource "aws_lb_listener" "github_api" {
#  load_balancer_arn = aws_lb.github_api.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    target_group_arn = aws_lb_target_group.github_api.arn
#    type             = "forward"
#  }
#}
