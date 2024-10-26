# variables.tf

variable "AWS_ACCESS_KEY_ID" {
  type = string
  description = "AWS Access Key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  description = "AWS Secret Access Key"
}

# Define the AWS region for resource deployment
variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # Change to your preferred region
}

# Define the AMI ID for the EC2 instances
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0866a3c8686eaeeba"  # Replace with a valid AMI ID for your region
}

# Define the instance type for the master node
variable "master_instance_type" {
  description = "EC2 instance type for Kubernetes master"
  type        = string
  default     = "t2.medium"  # Change based on your needs
}

# Define the instance type for the worker nodes
variable "worker_instance_type" {
  description = "EC2 instance type for Kubernetes workers"
  type        = string
  default     = "t2.micro"  # Change based on your needs
}

# Define the instance type for the monitoring server
variable "monitoring_instance_type" {
  description = "EC2 instance type for monitoring server"
  type        = string
  default     = "t2.small"  # Change based on your needs
}

# Define the number of worker instances to create
variable "worker_count" {
  description = "Number of Kubernetes worker instances to launch"
  type        = number
  default     = 2  # Change as needed
}

# Define tags to apply to the resources
variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {
    Name = "K8s-Instance"
  }
}
