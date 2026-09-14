# 🏫 Lesson 13 lab — a whole campus as code (free: no NAT, no desks)
# apply → read the corridor signs → destroy

variable "region" { default = "us-east-1" }
provider "aws" { region = var.region }

# the fence + the address plan
resource "aws_vpc" "campus" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "school-campus", project = "school-lab" }
}

# the main gate (exactly one per campus)
resource "aws_internet_gateway" "gate" {
  vpc_id = aws_vpc.campus.id
  tags   = { Name = "main-gate" }
}

# public wing: faces the street (building A)
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.campus.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-wing-a" }
}

# private wing: no street-facing windows (building A)
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.campus.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "${var.region}a"
  tags              = { Name = "private-wing-a" }
}

# corridor sign for the public wing: "everything else → the gate"
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.campus.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gate.id
  }
  tags = { Name = "sign-public" }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# the private wing keeps the VPC's default sign: local mail only, no gate.
# (a real campus would add a NAT postbox here — ~$32/month, so not in the lab;
#  lesson 20 reads you that bill)

output "vpc_id"    { value = aws_vpc.campus.id }
output "public_a"  { value = aws_subnet.public_a.id }
output "private_a" { value = aws_subnet.private_a.id }
