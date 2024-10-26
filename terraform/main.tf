provider "aws" {
  region = "us-east-1"  # or your desired region
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_instance" "k8s_master" {
  ami           = "ami-0866a3c8686eaeeba"  # Update with an appropriate AMI ID
  instance_type = "t2.medium"
  tags = {
    Name = "K8s-Master"
  }
}

resource "aws_instance" "k8s_worker" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  count         = 2
  tags = {
    Name = "K8s-Worker"
  }
}

resource "aws_security_group" "k8s_security_group" {
  name = "k8s-security-group"
  description = "Security group for Kubernetes nodes"

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
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

# Attach Security Group to EC2 Instances
resource "aws_instance" "monitoring_server" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.small"
  tags = {
    Name = "Monitoring-Server"
  }
}

output "master_ip" {
  value = aws_instance.k8s_master.public_ip
}

output "worker_ips" {
  value = aws_instance.k8s_worker[*].public_ip
}

output "monitoring_ip" {
  value = aws_instance.monitoring_server.public_ip
}
