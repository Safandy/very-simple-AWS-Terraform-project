resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow inbound HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALBSecurityGroup"
  }
}

# Create a Target Group for the EC2 Instances
resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.my_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "MyTargetGroup"
  }
}

# # Add the Two Private EC2 Instances to the Target Group
# resource "aws_lb_target_group_attachment" "ec2_instance_1" {
#   target_group_arn = aws_lb_target_group.my_target_group.arn
#   target_id        = aws_instance.server1.id
#   port             = 80
# }

# resource "aws_lb_target_group_attachment" "ec2_instance_2" {
#   target_group_arn = aws_lb_target_group.my_target_group.arn
#   target_id        = aws_instance.server2.id
#   port             = 80
# }

# Create an Application Load Balancer (ALB)
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  tags = {
    Name = "MyApplicationLoadBalancer"
  }
}

# Create Listener for the ALB
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}