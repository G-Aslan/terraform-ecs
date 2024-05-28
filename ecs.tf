# Create ECR repository
resource "aws_ecr_repository" "main" {
  name                 = "hello-world"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  lifecycle {
    ignore_changes = [encryption_configuration]
  }

  tags = {
    Name = "Gilad-Aslan-Task-Hello-World"
  }
}
# ECS task definition
resource "aws_ecs_task_definition" "main" {
  family                   = "MainTask"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256" # Define CPU allocation for the task
  memory                   = "512" # Define memory allocation for the task
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "hello-world"
      image     = "${aws_ecr_repository.main.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  tags = {
    Name = "Gilad Aslan Task Definition"
  }
}

# ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "GiladAslanCluster"
}

# ECS service
resource "aws_ecs_service" "main" {
  name                 = "hello-world"
  cluster              = aws_ecs_cluster.main.id
  task_definition      = aws_ecs_task_definition.main.arn
  desired_count        = 2
  launch_type          = "FARGATE"
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.private[*].id
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = "hello-world"
    container_port   = 80
  }

  tags = {
    Name = "Gilad Aslan Service"
  }
}