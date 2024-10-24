# Specify the AWS provider and region
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Define the Kubernetes master node
resource "aws_instance" "k8s-master" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with actual AMI for your region
  instance_type = "t2.medium"  # You can change based on your needs

  tags = {
    Name = "K8s-Master-Node"
  }
}

# Define Kubernetes worker nodes
resource "aws_instance" "k8s-worker" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"  # Scaling may require a larger instance type
  count         = 2  # Create 2 worker nodes by default

  tags = {
    Name = "K8s-Worker-Node"
  }
}

# Define security group for allowing SSH and Kubernetes traffic
resource "aws_security_group" "k8s_security_group" {
  name        = "k8s_security_group"
  description = "Security group for Kubernetes nodes"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH access from anywhere
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows Kubernetes API server access
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows kubelet API traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the master and worker node IPs
output "master_public_ip" {
  value = aws_instance.k8s-master.public_ip
}

output "worker_public_ips" {
  value = aws_instance.k8s-worker.*.public_ip
}
