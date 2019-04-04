variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "ap-south-1"
}

variable "aws_available_region" {
  description = "The AWS region to deploy into"
  default     = ["ap-south-1a"]
}

variable "aws_key_name" {
  default = "terraform"
}

variable "instance_count" {
  default = "3"
}

resource "aws_security_group" "web-node" {
  name = "web-node"
  description = "Web Security Group"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb" {
  name        = "elb_sg"
  description = "Used in the terraform"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}