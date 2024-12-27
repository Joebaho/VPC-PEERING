# ZONE OF RESOURCES

# -----------------------------Declare the data source for AZ-------------------
data "aws_availability_zones" "az_1" {
  state    = "available"
  provider = aws.region1
}

#---------------------------------------------- Creation of the West-VPC--------------------------------------------
resource "aws_vpc" "vpc_1" {
  provider             = aws.region1
  cidr_block           = var.vpc_cidr_block_1
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "vpc_west"
  }

}
#------------------------------------------- Create west Public Subnets-------------------------------------------
resource "aws_subnet" "public_subnet" {
  provider                = aws.region1
  count                   = var.mycount
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = var.public_subnet_cidrs_1[count.index]
  availability_zone       = data.aws_availability_zones.az_1.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet_${count.index + 1}"
  }
}
# --------------------------------West Internet gateway creation-------------------------------------------
resource "aws_internet_gateway" "igw" {
  provider = aws.region1
  vpc_id   = aws_vpc.vpc_1.id
  tags = {
    Name = "West_IGW"
  }
}
#------------------------------- Create a Route Table and associate it with the VPC-------------------------
resource "aws_route_table" "public_route" {
  provider = aws.region1
  vpc_id   = aws_vpc.vpc_1.id
  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public_Route"
  }
}
# ------------------------------------Public Subnet 1 Route table association---------------------------------
resource "aws_route_table_association" "public_subnet_association" {
  provider       = aws.region1
  count          = var.mycount
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route.id
}

#--------------------------------West NAT Gateway1 creation----------------------------------------------------
resource "aws_nat_gateway" "nat_gateway" {
  provider      = aws.region1
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet[0].id
  # connectivity_type = "private"
  tags = {
    Name = "West_NGW"
  }
  depends_on = [aws_internet_gateway.igw]
}
#-------------------------------------------Elastic IP 1 creation-----------------------------------------------
resource "aws_eip" "eip1" {
  provider = aws.region1
  tags = {
    Name = "West_EIP1"
  }
}
#-------------------------------------------- Create a Private Subnets----------------------------------
resource "aws_subnet" "private_subnet" {
  provider          = aws.region1
  count             = var.mycount
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.private_subnet_cidrs_1[count.index]
  availability_zone = data.aws_availability_zones.az_1.names[count.index]
  tags = {
    Name = "Private_Subnet_${count.index + 1}"
  }
}
#-----------------------------------------Private Route table1-------------------------------------------
resource "aws_route_table" "private_route" {
  provider = aws.region1
  vpc_id   = aws_vpc.vpc_1.id
  route {
    cidr_block     = var.public_cidr
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "Private_Route"
  }
}
# ------------------------------------Private Subnet 1 Route table association---------------------------------
resource "aws_route_table_association" "priv_assosubnet1" {
  provider       = aws.region1
  count          = var.mycount
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route.id
}
# -------------------------------------Creation for the public NACL---------------------------------
resource "aws_network_acl" "pub_nacl" {
  vpc_id   = aws_vpc.vpc_1.id
  provider = aws.region1

  egress {
    rule_no    = 10
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.public_cidr
    from_port  = var.port_number[2] #0
    to_port    = var.port_number[2] #0
  }
  ingress {
    rule_no    = 10
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.public_cidr
    from_port  = var.port_number[2] #0
    to_port    = var.port_number[2] #0
  }
  tags = {
    "Name" = "Pub_Nacl"
  }
}
#--------------------------------------------- Public NACL associations------------------------------------------
resource "aws_network_acl_association" "public_subnet_association1" {
  provider       = aws.region1
  count          = var.mycount
  subnet_id      = aws_subnet.public_subnet[count.index].id
  network_acl_id = aws_network_acl.pub_nacl.id
}
#------------------------------------------ Creation for the Private NACL----------------------------------------
resource "aws_network_acl" "priv_nacl" {
  vpc_id   = aws_vpc.vpc_1.id
  provider = aws.region1

  egress {
    rule_no    = 10
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.public_cidr
    from_port  = var.port_number[2] #0
    to_port    = var.port_number[2] #0
  }
  ingress {
    rule_no    = 10
    protocol   = "-1"
    action     = "allow"
    cidr_block = var.public_cidr
    from_port  = var.port_number[2] #0
    to_port    = var.port_number[2] #0
  }
  tags = {
    "Name" = "Priv_NACL"
  }
}
# --------------------------------Private NACL associations-----------------------------
resource "aws_network_acl_association" "private_subnet_association1" {
  provider       = aws.region1
  count          = var.mycount
  subnet_id      = aws_subnet.private_subnet[count.index].id
  network_acl_id = aws_network_acl.priv_nacl.id
}

