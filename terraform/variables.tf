# Define AWS region variable
variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  default     = "us-east-1"
}

# Define instance type for master node
variable "master_instance_type" {
  description = "EC2 instance type for Kubernetes master node"
  default     = "t2.medium"
}

# Define instance type for worker nodes
variable "worker_instance_type" {
  description = "EC2 instance type for Kubernetes worker nodes"
  default     = "t2.micro"
}

# Define the number of worker nodes
variable "worker_count" {
  description = "Number of Kubernetes worker nodes"
  default     = 2
}
