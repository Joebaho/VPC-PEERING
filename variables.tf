#Lists of all variables that will be use in the project
#----------Region1----------  
variable "region_name_1" {
  description = "Region name"
}
#----------Region2----------  
variable "region_name_2" {
  description = "Region name"
}
# ---------variable declarations for the public_cidr--------------------
variable "public_cidr" {
  type = string
}
# ----------variable declarations for the west-vpc_cidr1--------------------
variable "vpc_cidr_block_1" {
  type = string
}
# -----------variable declarations for the east-vpc_cidr2-----------------
variable "vpc_cidr_block_2" {
  type = string
}
# -----------Declarations for the two public_subnet_cidrs----------------
variable "public_subnet_cidrs_1" {
  type = list(string)
}
# -----------Declarations for the two public_subnet_cidrs---------------
variable "public_subnet_cidrs_2" {
  type = list(string)
}
# -------------Declarations for the two private_subnet_cidrs-------------
variable "private_subnet_cidrs_1" {
  type = list(string)
}
# -------------Declarations for the two private_subnet_cidrs-------------
variable "private_subnet_cidrs_2" {
  type = list(string)
}
# --------------variable declarations for port-------------------
variable "port_number" {
  type        = list(number)
  description = "list of port number for security group ingress and egress rules"
}
# -------------variable declarations for the public server launched---------
variable "mycount" {
  type        = number
  description = "index of the server launched"
}