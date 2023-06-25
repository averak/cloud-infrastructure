resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.domain}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "${var.domain}-public-subnet-${count.index + 1}"
  }
}

#resource "aws_subnet" "private" {
#  count = length(var.availability_zones)
#
#  vpc_id            = aws_vpc.main.id
#  availability_zone = var.availability_zones[count.index]
#  cidr_block        = var.private_subnet_cidrs[count.index]
#
#  tags = {
#    Name = "${var.domain}-private-subnet-${count.index + 1}"
#  }
#}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.domain}-internet-gateway"
  }
}

#resource "aws_eip" "main" {
#  count = length(var.availability_zones)
#
#  domain = "vpc"
#
#  tags = {
#    Name = "${var.domain}-nat-gateway-eip-${count.index + 1}"
#  }
#}
#
#resource "aws_nat_gateway" "main" {
#  count = length(var.availability_zones)
#
#  subnet_id     = aws_subnet.public[count.index].id
#  allocation_id = aws_eip.main[count.index].id
#
#  tags = {
#    Name = "${var.domain}-nat-gateway-${count.index + 1}"
#  }
#}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.domain}-public-route-table"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#resource "aws_route_table" "private" {
#  count = length(var.availability_zones)
#
#  vpc_id = aws_vpc.main.id
#
#  tags = {
#    Name = "${var.domain}-private-route-table-${count.index + 1}"
#  }
#}
#
#resource "aws_route" "private" {
#  count = length(var.availability_zones)
#
#  destination_cidr_block = "0.0.0.0/0"
#  route_table_id         = aws_route_table.private[count.index].id
#  nat_gateway_id         = aws_nat_gateway.main[count.index].id
#}
#
#resource "aws_route_table_association" "private" {
#  count = length(var.availability_zones)
#
#  subnet_id      = aws_subnet.private[count.index].id
#  route_table_id = aws_route_table.private[count.index].id
#}
