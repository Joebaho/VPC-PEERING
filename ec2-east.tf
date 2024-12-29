#----------------------------------Declare the data source for the latest AMI----------------------------------------
data "aws_ami" "amazon_linux_2" {
  provider      = aws.region2
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
resource "aws_instance" "server_east" {
  provider      = aws.region2
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.east_web_sg.id]
  key_name               = var.east_key_name
  subnet_id              = aws_subnet.private2_subnet[0].id
  tags = {
    Name = "server-east"
  }
}
#-------------------------Security group------------------------
resource "aws_security_group" "east_web_sg" {
  provider    = aws.region2
  name        = "web-sg"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.vpc_2.id
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from anywhere"
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
    Name = "east-web-sg"
  }
}