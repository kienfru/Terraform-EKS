output "cluster_id" {
  value = aws_eks_cluster.kien.id
}

output "node_group_id" {
  value = aws_eks_node_group.kien.id
}

output "vpc_id" {
  value = aws_vpc.kien_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.kien_subnet[*].id
}

