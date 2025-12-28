provider "aws" {
  region = "ap-south-1"
  # credentials picked automatically from environment
}

resource "aws_instance" "demo" {
  ami           = "ami-0f5ee92e2d63afc18" # Amazon Linux 2023 Mumbai
  instance_type = "t2.micro"

  tags = {
    Name = "jenkins-terraform-demo"
  }
}
