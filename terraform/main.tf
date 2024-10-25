provider "aws" {
  region     = "us-east-1" # replace with your region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_instance" "k8s-master" {
  ami           = var.ami_id
  instance_type = var.master_instance_type

  tags = {
    Name = "K8s-Master-Node-${var.master_instance_type}"
  }
}

resource "aws_instance" "k8s-worker" {
  ami           = var.ami_id
  instance_type = var.worker_instance_type
  count         = 2

  tags = {
    Name = "K8s-Worker-Node-${var.worker_instance_type}-${count.index + 1}"  # Corrected usage
  }
}

resource "aws_security_group" "k8s_security_group" {
  name        = "k8s_security_group"
  description = "Security group for Kubernetes nodes"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["34.234.67.235 /32"]  # Replace with a valid IP address
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open access, adjust for security
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open access, adjust for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "k8s_master_public_ip" {
  value = aws_instance.k8s-master.public_ip
}

output "k8s_worker_public_ips" {
  value = aws_instance.k8s-worker[*].public_ip  # Use the correct syntax for multiple instances
}
