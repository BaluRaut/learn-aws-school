# One rented computer, as code (lessons 07–12 in ~60 lines):
# a t3.micro (free-tier eligible) + gatekeeper rules + a role-hat + a boot checklist.
#   terraform init && terraform apply     (⚠️ costs pennies/hour — destroy when done!)
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = var.region
}

variable "region" { default = "ap-south-1" }
variable "my_ip"  { description = "Your IP for SSH, e.g. 1.2.3.4/32" }

# Latest Amazon Linux 2023 AMI — the "fully set-up desk template" (lesson 11)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# The gatekeeper's guest list 🚪 (lesson 10)
resource "aws_security_group" "school_desk" {
  name = "school-desk-sg"
  ingress {                       # SSH: only from YOUR house
    from_port = 22, to_port = 22, protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {                       # web: everyone may knock on 80
    from_port = 80, to_port = 80, protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {                        # outbound: allowed (updates, downloads)
    from_port = 0, to_port = 0, protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The role-hat for the machine 🎩 (lessons 04–05, 12) — no keys on the box!
resource "aws_iam_role" "desk_role" {
  name               = "school-desk-role"
  assume_role_policy = file("${path.module}/../iam/ec2-role-trust-policy.json")
}

resource "aws_iam_instance_profile" "desk_profile" {
  name = "school-desk-profile"
  role = aws_iam_role.desk_role.name
}

# The rented computer itself 🖥️ (lessons 07–08)
resource "aws_instance" "school_desk" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"                  # small scooter, free-tier eligible
  vpc_security_group_ids = [aws_security_group.school_desk.id]
  iam_instance_profile   = aws_iam_instance_profile.desk_profile.name

  user_data = file("${path.module}/user-data.sh")      # the boot checklist 📋 (lesson 12)

  root_block_device {
    volume_size = 8                                     # the desk drawer 🗄️ (lesson 11)
  }

  tags = { Name = "school-desk" }
}

output "public_ip" { value = aws_instance.school_desk.public_ip }
