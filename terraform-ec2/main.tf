provider "aws" {
  region = "ap-northeast-1"
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "LatihanPrivateKeyPairKelompok4" {
  filename = "latihanKeyPair.pem"
  content  = tls_private_key.rsa.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "LatihanKeyPairKelompok4" {
  key_name   = "latihanKeyPair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "aws_security_group" "latihan-security-group" {
  description = "Allow limited inbound external traffic"
  name        = "latihan-sg-Kelompok4"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name = "latihan-sg-Kelompok4"
  }
}

resource "aws_instance" "latihan-ec2" {
  ami           = "ami-036cea36e8ba45387"
  instance_type = "t3.micro"

  key_name = aws_key_pair.LatihanKeyPairKelompok4.key_name

  vpc_security_group_ids = [
    aws_security_group.latihan-security-group.id
  ]

  user_data = file("scriptku.sh")

  tags = {
    Name = "latihan-ec2"
  }
}

output "ec2_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.latihan-ec2.public_ip
}

output "ssh_connection_string" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i latihanKeyPair.pem admin@${aws_instance.latihan-ec2.public_ip}"
}