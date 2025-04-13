resource "aws_security_group" "private_ec2_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow inbound SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update CIDR for restricted access
  }

  # Allow inbound HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update CIDR for restricted access
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PrivateEC2SecurityGroup"
  }
}

## Template for Ec2 instances

resource "aws_launch_template" "asg_launch_template" {
  name_prefix   = "my-asg-template"
  image_id           = "ami-00a929b66ed6e0de6"  
  instance_type = "t2.micro"               # Free-tier eligible instance type
  key_name        = "keyLama"  # Replace this with your key pair

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_ec2_sg.id]
  }
   # User Data Script to Install Nginx on Instance Start
  user_data = base64encode(<<EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx

# Create a custom index.html file
echo "<html><head><title>Welcome Sandy</title></head><body><h1>Congrats your web app is working as expected</h1></body></html>" | sudo tee /usr/share/nginx/html/index.html


sudo systemctl start nginx
sudo systemctl enable nginx
EOF
  )


  tags = {
    Name = "ASGLaunchTemplate"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "my_asg" {
  name                = "my-auto-scaling-group"
  min_size            = 2   # Minimum number of instances
  max_size            = 5   # Maximum number of instances
  desired_capacity    = 2   # Desired instance count at startup
  vpc_zone_identifier = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  target_group_arns   = [aws_lb_target_group.my_target_group.arn]

  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }
}

# Scaling Policy (Example: Scale up when CPU utilization > 75%)
resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 75
  alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_asg.name
  }
}


