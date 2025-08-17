variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}
resource "aws_security_group" "sg_1" {
  name = "kimang-security"

  ingress {
    description = "App Port"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "_key" {
  key_name   = "node-key-2"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWENFu1t/fiqRN3/qGneoBd0zXYQu2gOhraO3Trvz5D my-node-app-key"
}

resource "aws_instance" "server_1" {
  ami                         = var.ami_id
  instance_type               = "t3.xlarge"
  key_name                    = aws_key_pair._key.key_name
  security_groups             = [aws_security_group.sg_1.name]
  user_data_replace_on_change = true
}