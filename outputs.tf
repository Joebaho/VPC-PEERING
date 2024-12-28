# OUTPUTS SECTION

#output of the private Ip of both instances
output "east_instance_private_Ip" {
  value = aws_instance.server_east.private_ip
}
output "west_instance_private_Ip" {
  value = aws_instance.server_west.private_ip
}
#output of the vpcs
output "east_vpc_id" {
  value = aws_vpc.vpc_2.id
}
output "west_vpc_id" {
  value = aws_vpc.vpc_1.id
}

