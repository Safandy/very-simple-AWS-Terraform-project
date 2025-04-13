resource "aws_instance" "jumb_server" {
  ami           = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"               # Free-tier eligible instance type
  key_name        = "keyLama"    # Replace this with your key pair

  subnet_id = aws_subnet.public_subnet_1.id

  # Auto-assign a public IP address
  associate_public_ip_address = true

  # Security Group for SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.jumbServer_sg.id]

  tags = {
    Name = "jumb_server"
  }
}

# Create a Security Group for EC2
resource "aws_security_group" "jumbServer_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow inbound SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update this to restrict SSH access if needed
  }

  # Allow inbound HTTP access
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
    Name = "Myjumb_serverGroup"
  }
}