resource "aws_vpc" "my_vpc" {
  cidr_block = "172.4.0.0/16"
  tags = {
    Name = "student.4-vpc"
  }
}

# Create a Public Subnet
resource "aws_subnet" "my_public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.4.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "student.4-public-subnet"
  }
}

# Create a IG
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "igw-student-4"
  }
}


resource "aws_route_table" "my_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "subnet-rt-student-4"

    }
}
resource "aws_route_table_association" "my_rt" {
    subnet_id = aws_subnet.my_public_subnet.id
    route_table_id = aws_route_table.my_rt.id

}
resource "aws_security_group" "my_sg" {
  name        = "student-4"
  description = "Allow SSH & HTTP inbound connections"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30100
    to_port     = 30100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 32000
    to_port     = 32000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-student-4"
  }
}

