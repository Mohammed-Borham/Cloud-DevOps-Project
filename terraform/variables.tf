variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones (for subnets)"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "key_name" {
  description = "SSH key name (for EC2 workers, can be empty)"
  type        = string
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the worker nodes"
  type        = list(string)
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "node_desired_count" {
  description = "Desired number of worker nodes"
  type        = number
}
