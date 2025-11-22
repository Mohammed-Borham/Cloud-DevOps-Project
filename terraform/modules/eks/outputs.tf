output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint URL of the EKS cluster"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.cluster.arn
}

output "node_group_name" {
  description = "Name of the worker node group"
  value       = aws_eks_node_group.node_group.node_group_name
}

output "node_role_arn" {
  description = "ARN of the worker node IAM role"
  value       = aws_iam_role.eks_node_role.arn
}
