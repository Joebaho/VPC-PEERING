#----------------------------------Declare the data source for the latest AMI----------------------------------------
data "aws_ami" "amazon_linux_1" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "west_server" {
  ami           = data.aws_ami.amazon_linux_1.id
  instance_type = var.instance_type
  #availability_zone      = data.aws_availability_zones.az_1
  vpc_security_group_ids = [aws_security_group.west_web_sg.id]
  key_name               = var.west_key_name
  subnet_id              = aws_subnet.private_subnet[0].id
  tags = {
    Name = "server-west"
  }
}
#----------------------------------Declare the security group for the EC2 instance----------------------------------------
resource "aws_security_group" "west_web_sg" {
  name        = "web-sg"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.vpc_1.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ICMP from anywhere"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "west-web-sg"
  }
}