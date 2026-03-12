provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "latihan_ec2" {
  ami           = "ami-036cea36e8ba45387"
  instance_type = "t3.micro"
  key_name      = "key_name"

  tags = {
    Name = "latihan-ec2"
  }
}