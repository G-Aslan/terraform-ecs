# Define Docker build and push
resource "null_resource" "docker_build_and_push" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      # Log in to ECR
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com

      # Build Docker image
      docker build -t hello-world .

      # Tag Docker image
      docker tag hello-world:latest ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/hello-world:latest

      # Push Docker image to ECR
      docker push ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/hello-world:latest
    EOF
  }
}