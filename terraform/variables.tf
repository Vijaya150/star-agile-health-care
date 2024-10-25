variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the Kubernetes master and worker nodes"
  type        = string
}

variable "master_instance_type" {
  description = "Instance type for the Kubernetes master"
  type        = string
  default     = "t2.micro"  # Adjust the default as needed
}

variable "worker_instance_type" {
  description = "Instance type for the Kubernetes workers"
  type        = string
  default     = "t2.micro"  # Adjust the default as needed
}
