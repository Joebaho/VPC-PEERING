# ZONE OF RESOURCES

# --------------------------------Declare the data source for AZ--------------------------
data "aws_availability_zones" "az_2" {
  state    = "available"
  provider = aws.region2
}

#---------------------------------------------- Creation of the East-VPC--------------------------------------------
resource "aws_vpc" "vpc_2" {
  provider             = aws.region2
  cidr_block           = var.vpc_cidr_block_2
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "vpc_east"
  }

}
#------------------------------------------- Create east Public Subnets-------------------------------------------
resource "aws_subnet" "public2_subnet" {
  provider                = aws.region2
  count                   = var.mycount
  vpc_id                  = aws_vpc.vpc_2.id
  cidr_block              = var.public_subnet_cidrs_2[count.index]
  availability_zone       = data.aws_availability_zones.az_2.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public2_Subnet_${count.index + 1}"
  }
}
# ------------------------------East Internet gateway creation-------------------------------------------
resource "aws_internet_gateway" "igw2" {
  provider = aws.region2
  vpc_id   = aws_vpc.vpc_2.id
  tags = {
    Name = "E_IGW"
  }
}
#------------------------------- Create a Route Table and associate it with the VPC-------------------------
resource "aws_route_table" "public2_route" {
  provider = aws.region2
  vpc_id   = aws_vpc.vpc_2.id
  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.igw2.id
  }
  tags = {
    Name = "Public2_Route"
  }
}
# -----------------------------east Public Subnet Route table association---------------------------------
resource "aws_route_table_association" "public2_subnet_association" {
  provider       = aws.region2
  count          = var.mycount
  subnet_id      = aws_subnet.public2_subnet[count.index].id
  route_table_id = aws_route_table.public2_route.id
}

#---------------------------------East-NAT Gateway creation----------------------------------------------------
resource "aws_nat_gateway" "nat2_gateway" {
  provider      = aws.region2
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public2_subnet[0].id
  # connectivity_type = "private"
  tags = {
    Name = "E_NGW"
  }
}
#-------------------------------------------Elastic IP 2 creation-----------------------------------------------
resource "aws_eip" "eip2" {
  provider = aws.region2
  tags = {
    Name = "E_EIP2"
  }
}
#-------------------------------------------- Create East Private Subnets----------------------------------
resource "aws_subnet" "private2_subnet" {
  provider          = aws.region2
  count             = var.mycount
  vpc_id            = aws_vpc.vpc_2.id
  cidr_block        = var.private_subnet_cidrs_2[count.index]
  availability_zone = data.aws_availability_zones.az_2.names[count.index]
  tags = {
    Name = "Private2_Subnet_${count.index + 1}"
  }
}
#-----------------------------------------Private Route table2-------------------------------------------
resource "aws_route_table" "private2_route" {
  vpc_id   = aws_vpc.vpc_2.id
  provider = aws.region2
  route {
    cidr_block     = var.public_cidr
    nat_gateway_id = aws_nat_gateway.nat2_gateway.id
  }
  tags = {
    Name = "Private2_Route"
  }
}
# ------------------------------------Private Subnet 1 Route table association---------------------------------
resource "aws_route_table_association" "priv2_assosubnet1" {
  count          = var.mycount
  provider       = aws.region2
  subnet_id      = aws_subnet.private2_subnet[count.index].id
  route_table_id = aws_route_table.private2_route.id
}
# -------------------------------------Creation for the public NACL---------------------------------
resource "aws_network_acl" "pub2_nacl" {
  vpc_id   = aws_vpc.vpc_2.id
  provider = aws.region2

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
resource "aws_network_acl_association" "public2_subnet_association1" {
  count          = var.mycount
  provider       = aws.region2
  subnet_id      = aws_subnet.public2_subnet[count.index].id
  network_acl_id = aws_network_acl.pub2_nacl.id
}
#------------------------------------------ Creation for the Private NACL----------------------------------------
resource "aws_network_acl" "priv2_nacl" {
  vpc_id   = aws_vpc.vpc_2.id
  provider = aws.region2

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
# ----------------------------------Private NACL associations------------------------
resource "aws_network_acl_association" "private2_subnet_association1" {
  count          = var.mycount
  provider       = aws.region2
  subnet_id      = aws_subnet.private2_subnet[count.index].id
  network_acl_id = aws_network_acl.priv2_nacl.id
}

