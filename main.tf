# CREATE A VPC RESOURCE
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}


# CREATE A SUBNET RESOURCE
resource "aws_subnet" "main_public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1b"

  tags = {
    Name = "dev-public"
  }
}

# CREATE AN INTERNET GATEWAY RESOUCE
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# CREATE AWS ROUTE TABLE
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "dev-rt"
  }
}

# CREATE AWS ROUTE RESOURCE
resource "aws_route" "main_route" {
  route_table_id         = aws_route_table.main_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_internet_gateway.id
}

# CREATE ROUTE TABLE ASSOCIATION TO SUBNET
resource "aws_route_table_association" "rt-subnet-assoc" {
  subnet_id      = aws_subnet.main_public_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

# # CREATE ROUTE TABLE ASSOCIATION TO INTERNET GATEWAY
# resource "aws_route_table_association" "rt-gw-assoc" {
#   gateway_id = aws_internet_gateway.main_internet_gateway.id
#   route_table_id = aws_route_table.main_route_table.id
# }

# CREATE SECURITY GROUP
resource "aws_security_group" "main_sg" {
  name        = "dev_sg"
  description = "dev main security group"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# CREATE EC2 KEY PAIR
resource "aws_key_pair" "main_key_pair" {
  key_name   = "main_terraform"
  public_key = file("~/.ssh/main_terraform.pub")
}

# CREATE AN EC2 INSTANCE
resource "aws_instance" "main_instance" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.main_key_pair.id
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  subnet_id              = aws_subnet.main_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "Terraform"
  }

  provisioner "local-exec" {
    command = templatefile("linux-ssh-config.tpl", {
      hostname = self.public_ip,
      user = "ubuntu",
      identityfile = "~/.ssh/main_terraform"
    })
    interpreter = ["bash", "-c"]
  }
}