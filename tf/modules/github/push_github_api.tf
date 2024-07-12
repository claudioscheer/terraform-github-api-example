#resource "null_resource" "push_github_api" {
#  depends_on = [aws_ecr_repository.github_api]
#
#  provisioner "local-exec" {
#    command = "docker build -t github-api:${var.github_api_version} ${path.root}/../../microservices/github-api"
#  }
#
#  provisioner "local-exec" {
#    command = "docker tag github-api:${var.github_api_version} ${aws_ecr_repository.github_api.repository_url}:${var.github_api_version}"
#  }
#
#  provisioner "local-exec" {
#    command = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.github_api.repository_url}"
#  }
#
#  provisioner "local-exec" {
#    command = "docker push ${aws_ecr_repository.github_api.repository_url}:${var.github_api_version}"
#  }
#
#  triggers = {
#    version = var.github_api_version
#  }
#}
