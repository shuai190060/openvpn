resource "aws_vpc" "main_openvpn" {
  cidr_block = var.vpc_cidr
  # enable_dns_hostnames = true
  # enable_dns_support = true

  tags = var.tags

}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main_openvpn.id
  cidr_block              = var.public_cidrblock
  map_public_ip_on_launch = true

  tags = {
    "name" = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main_openvpn.id
  cidr_block = var.private_cidrblock

  tags = {
    "name" = "private"
  }
}

# public setup
resource "aws_internet_gateway" "igw_openvpn" {
  vpc_id = aws_vpc.main_openvpn.id
  tags   = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_openvpn.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_openvpn.id
  }
  tags = {
    "name" = "public route"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# private setup
resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    "name" = "nat"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_openvpn.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    "name" = "private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}