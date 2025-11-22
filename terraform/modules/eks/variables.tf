variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster (use public subnets)"
  type        = list(string)
}

variable "key_name" {
  description = "SSH key name for worker nodes (empty if none)"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types for the worker nodes"
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
