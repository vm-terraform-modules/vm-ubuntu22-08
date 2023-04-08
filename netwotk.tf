# variable "vpc_info" {
#   type = object({
#     subnet_names   = list(string)
#     public_subnets = list(string)
#   })
#   default = {
#     public_subnets = ["web"]
#     subnet_names   = ["web", "app", "db", "test"]
#   }
resource "aws_vpc" "ntier" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "ntier"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id            = aws_vpc.ntier.id
  count             = length(var.vpc_info.subnet_names)
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = "${var.region}${var.vpc_info.zones[count.index % 2]}"
  tags = {
    Type = contains(var.vpc_info.public_subnets, var.vpc_info.subnet_names[count.index]) ? "public" : "private"
    Name = var.vpc_info.subnet_names[count.index]
  }
  depends_on = [
    aws_vpc.ntier
  ]
}

resource "aws_internet_gateway" "ntier_igw" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "ntier_igw"
  }
  depends_on = [
    aws_vpc.ntier
  ]
}
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.ntier.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ntier_igw.id
  }
  tags = {
    Name = "publicRT"
  }
  depends_on = [
    aws_internet_gateway.ntier_igw
  ]
}
resource "aws_route_table_association" "publicRTAsociations" {
  route_table_id = aws_route_table.publicRT.id
  count          = length(var.vpc_info.public_subnets)
  subnet_id      = data.aws_subnets.public_subnets.ids[count.index]
}

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "privateRT"
  }
  depends_on = [
    aws_internet_gateway.ntier_igw
  ]
}
