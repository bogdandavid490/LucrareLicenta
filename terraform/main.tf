provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "emagazin_instance" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "emagazin-instance"
  }
}
