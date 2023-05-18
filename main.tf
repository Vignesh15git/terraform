terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 3.0"
    }
  }
}

resource "aws_vpc" "VPC-01" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MY-VPC"
  }
}
resource "aws_vpc" "VPC-01A" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MY-VPC"
    provider = "aws.viki"
  }
}
resource "aws_subnet" "PUB-SUB" {
  vpc_id     = "aws_vpc.VPC-01.id"
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Main"
  }
}
resource "aws_subnet" "PVT-SUB" {
  vpc_id     = aws_vpc.VPC-01.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Main"
  }
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC-01.id
  depends_on = [aws_vpc.VPC-01]

  tags = {
    Name = "main"
  }
}
resource "aws_route_table" "PUB-RT" {
  vpc_id = aws_vpc.VPC-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "PUB-RT"
  }
}
resource "aws_nat_gateway" "myngw" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.PUB-SUB.id

  tags = {
    Name = "gw NAT"
  }

}
resource "aws_eip" "myeip" {
  #instance = aws_instance.web.id
  vpc      = true
}
resource "aws_route_table" "PVT-RT" {
  vpc_id = aws_vpc.VPC-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.myngw.id
  }
  tags = {
    Name = "Pvt-RT"
  }
}
resource "aws_route_table_association" "RT-ASSOCIATION-1" {
  subnet_id      = aws_subnet.PUB-SUB.id
  route_table_id = aws_route_table.PUB-RT.id
}
resource "aws_route_table_association" "RT-ASSOCIATION-2" {
  subnet_id      = aws_subnet.PVT-SUB.id
  route_table_id = aws_route_table.PVT-RT.id
}
resource "aws_security_group" "SG-01" {
  name        = "SG-01"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.VPC-01.id

  ingress {
    description      = "ALL TCP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.VPC-01.cidr_block]
    }
   ingress {         
    description      = "ALL TCP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.VPC-01.cidr_block]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-01"
  }
}
resource "aws_security_group" "SG-02" {
  name        = "SG-02"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.VPC-01.id

  ingress {
    description      = "ALL TCP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.SG-01.id]
    }
   ingress {         
    description      = "ALL TCP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.SG-01.id]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-02"
  }
}

resource "aws_instance" "PUB-SER" {
  ami           = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.PUB-SUB.id
  vpc_security_group_ids = ["${aws_security_group.SG-01.id}"]
  associate_public_ip_address = true
  key_name                     = "12345"
  //user_data = file("apache.sh")


  tags = {
    Name = "webserver"
  }
}
resource "aws_instance" "PVT-SER" {
  ami           = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.PUB-SUB.id
  vpc_security_group_ids = ["${aws_security_group.SG-02.id}"]
  associate_public_ip_address = true
  key_name                     = "12345"
  //count         = var.ec2_instance_count
  tags = {
    "Name" = "Appserver"
    
  
  }
}
