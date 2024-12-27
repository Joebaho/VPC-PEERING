#-----------------------vpc-peering request------------------------
resource "aws_vpc_peering_connection" "vpc-peering" {
  provider    = aws.region1
  peer_vpc_id = aws_vpc.vpc_2.id # Requester
  vpc_id      = aws_vpc.vpc_1.id # Accepter
  peer_region = "us-east-1"
  auto_accept = false
  tags = {
    Name = "VPC Peering between vpc_west and vpc_east"
  }
}
#-----------------------vpc-peering accepter------------------------
resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = aws.region2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
  auto_accept               = true
  tags = {
    Name = "accepter peering from vpc_west and vpc_east"
  }
}
# -----------------------Routes for VPC peering--------------------------
resource "aws_route" "peer_route_1_private" {
  provider                  = aws.region1
  route_table_id            = aws_route_table.private_route.id
  destination_cidr_block    = var.vpc_cidr_block_2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}
resource "aws_route" "peer_route_1_public" {
  provider                  = aws.region1
  route_table_id            = aws_route_table.public_route.id
  destination_cidr_block    = var.vpc_cidr_block_2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}
resource "aws_route" "peer_route_2_private" {
  provider                  = aws.region2
  route_table_id            = aws_route_table.private2_route.id
  destination_cidr_block    = var.vpc_cidr_block_1
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}
resource "aws_route" "peer_route_2_public" {
  provider                  = aws.region2
  route_table_id            = aws_route_table.public2_route.id
  destination_cidr_block    = var.vpc_cidr_block_1
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering.id
}


