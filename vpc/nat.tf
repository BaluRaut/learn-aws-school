# 📮 Lesson 22 lab — the postbox, per building
# ⚠️ A NAT gateway bills ~$0.045/HOUR + $0.045/GB the moment it exists. Apply, look, DESTROY.
# Off by default: terraform apply -var enable_nat=true

variable "enable_nat" { default = false }

resource "aws_eip" "nat_a" {
  count  = var.enable_nat ? 1 : 0
  domain = "vpc"
  tags   = { Name = "postbox-address-a", project = "school-lab" }
}

resource "aws_nat_gateway" "a" {
  count         = var.enable_nat ? 1 : 0
  allocation_id = aws_eip.nat_a[0].id
  subnet_id     = aws_subnet.public_a.id            # the postbox stands in the PUBLIC wing
  depends_on    = [aws_internet_gateway.gate]
  tags          = { Name = "postbox-a", project = "school-lab" }
}

# the private wing's corridor sign: "everything else → the postbox in MY building"
resource "aws_route_table" "private_a" {
  count  = var.enable_nat ? 1 : 0
  vpc_id = aws_vpc.campus.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.a[0].id
  }
  tags = { Name = "sign-private-a" }
}

resource "aws_route_table_association" "private_a" {
  count          = var.enable_nat ? 1 : 0
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a[0].id
}

# a real campus repeats this block per AZ (nat_b in public_b → private_b), never cross-AZ.
output "postbox_ip" { value = var.enable_nat ? aws_eip.nat_a[0].public_ip : "NAT disabled (good — it bills hourly)" }
