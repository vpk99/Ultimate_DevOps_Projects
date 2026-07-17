# Creating vpc
resource "aws_vpc" "ntier" {
  cidr_block = var.network_info.cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = var.network_info.name
  }
}



# creating private subnets 

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "private_subnets"
  }
  depends_on = [aws_vpc.ntier]

}

# Creating public subnets 

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "public_subnets"
  }
  depends_on = [aws_vpc.ntier]
}

# Creating internet gateway and attach to vpc

resource "aws_internet_gateway" "ntier" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "ntier"
  }
  depends_on = [aws_vpc.ntier]
}


# Creating eip

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
  depends_on = [ aws_vpc.ntier, aws_subnet.public ]
}
# Creating NAT gateway

resource "aws_nat_gateway" "main" {
  count = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public[count.index].id

  tags = {
  Name = "NAT_gateway"
  }

  depends_on = [ aws_eip.nat, aws_subnet.public, aws_vpc.ntier ]
}

# Creating Route table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ntier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ntier.id
  }
  tags = {
    Name = "public_rt"
  }
  depends_on = [aws_vpc.ntier, aws_vpc.ntier, aws_subnet.public]
}

# Creating route table for private subnets

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ntier.id
  route  {
    cidr_block = "0.0.0.0/0"
     gateway_id = aws_nat_gateway.main[0].id
  }
  depends_on = [ aws_vpc.ntier, aws_subnet.private ]

  tags = {
  Name = "private_rt"
  }
}

# Associate the public route table to public subnets

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
  depends_on     = [aws_route_table.public, aws_subnet.public]
}


# Associate the private route table to private subnets

resource "aws_route_table_association" "name" {
  count = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private[count.index].id
  depends_on = [ aws_route_table.private ]
}