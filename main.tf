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