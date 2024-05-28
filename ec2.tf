# Create security groups for ALB
resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Gilad Aslan Task ALBSecurityGroup"
  }

  # Inbound rule allowing HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule allowing all traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security groups for ECS
resource "aws_security_group" "ecs" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Gilad Aslan Task ECSSecurityGroup"
  }

  # Inbound rule allowing HTTP traffic from ALB security group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Outbound rule allowing all traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Application Load Balancer
resource "aws_lb" "main" {
  name               = "GiladAslan-Task-MainALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id

  security_groups = [
    aws_security_group.alb.id,
  ]

  tags = {
    Name = "Gilad Aslan Task MainALB"
  }
}

# Create Target Group
resource "aws_lb_target_group" "ecs" {
  name        = "ECSFargateTargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip" # Change target type to 'ip'

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Gilad Aslan Task ECSFargateTargetGroup"
  }
}

# Create Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

# Create rule
resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  condition {
    path_pattern {
      values = ["/app/*"]
    }
  }
}