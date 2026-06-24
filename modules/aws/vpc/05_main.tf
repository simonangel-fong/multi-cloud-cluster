# main.tf

# ##############################
# VPC
# ##############################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.vpc_tags,
    { Name = var.vpc_name }
  )
}

# ##############################
# Internet Gateway
# ##############################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.vpc_name
  }
}

# ##############################
# Public subnet
# ##############################
resource "aws_subnet" "public" {
  for_each = toset(local.public_azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, index(local.public_azs, each.value))
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-${each.value}-public-subnet"

    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
    "kubernetes.io/role/elb"                = "1"
  }
}

# rt public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

# Route Table Associations: public
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ##############################
# Private subnet
# ##############################
resource "aws_subnet" "private" {
  for_each = toset(local.azs)

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 2, index(local.azs, each.value) + 1)

  tags = {
    Name = "${var.vpc_name}-${each.value}-private-subnet"

    "kubernetes.io/cluster/${var.vpc_name}" = "shared"
    "kubernetes.io/role/internal-elb"       = "1"
    "karpenter.sh/discovery"                = var.vpc_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# ##############################
# Private NAT
# ##############################
# eip
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[local.public_azs[0]].id

  tags = {
    Name = "${var.vpc_name}-nat"
  }

  depends_on = [aws_internet_gateway.this]
}
