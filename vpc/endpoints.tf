# 🚇 Lesson 21 lab — a private corridor to the locker room (S3), free
# Adds a gateway endpoint to lesson 13's campus: private desks reach S3 with no gate, no postbox.

data "aws_route_table" "private_a" {
  subnet_id = aws_subnet.private_a.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.campus.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [data.aws_route_table.private_a.id]   # adds "S3 prefixes → endpoint" to the sign
  tags              = { Name = "private-corridor-to-s3", project = "school-lab" }
}

output "s3_endpoint" { value = aws_vpc_endpoint.s3.id }
