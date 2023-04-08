resource "aws_security_group" "ntier_sg" {
  name        = "ntier_sg"
  description = "Allow 80 and 22 traffic"
  vpc_id      = aws_vpc.ntier.id

  ingress {
    description = "allows 80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allows 22 port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allows 22 port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ntier_sg"
  }
}
resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file("./id_rsa.pub")
}

resource "aws_instance" "web_instance" {
  count                       = length(var.instance_names)
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ntier_sg.id]
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.public_subnets.ids[0]
  key_name                    = aws_key_pair.mykeypair.key_name

  tags = {
    Name = var.instance_names[count.index]
  }
  depends_on = [
    data.aws_subnets.public_subnets,
    aws_subnet.subnets,
    aws_security_group.ntier_sg
  ]
}
# resource "aws_instance" "blue" {
#   ami           = var.ami_id
#   instance_type = "t2.micro"
# vpc_security_group_ids = [aws_security_group.ntier_sg.id ]
# associate_public_ip_address = true
# subnet_id = data.aws_subnets.public_subnets.ids[0]
# key_name = aws_key_pair.mykeypair.key_name 

#   tags = {
#     Name = "blue"
#   }
#     depends_on = [
#     data.aws_subnets.public_subnets,
#     aws_subnet.subnets,
#     aws_security_group.ntier_sg
#   ]
# }

# resource "null_resource" "pet_clinic_install" {
#   triggers = {
#    instance_where_to_run=var.instance_where_to_run
#   }
#   connection {
#     type = "ssh"
#     user = "ubuntu"
#     private_key = file("./id_rsa")
#     host = aws_instance.blue.public_ip
#   }
#   provisioner "remote-exec" {
#     script=""
#   }
# }