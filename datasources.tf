data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.ntier.id]
  }
  tags = {
    "Type" = "public"
  }
  depends_on = [
    aws_subnet.subnets
  ]
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.ntier.id]
  }
  tags = {
    "Type" = "private"
  }
  depends_on = [
    aws_subnet.subnets
  ]
}
data "aws_instance" "deploy_inst" {
   filter {
    name   = "vpc-id"
    values = [aws_vpc.ntier.id]
  }
   filter {
    name   = "tag:Name"
    values = var.deploy_inst_name
  }
}