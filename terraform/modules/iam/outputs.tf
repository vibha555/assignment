output "eks_cluster_role_arn" { value = aws_iam_role.eks_cluster.arn }
output "eks_node_role_arn" { value = aws_iam_role.eks_node.arn }
output "cluster_policy_attachment" { value = aws_iam_role_policy_attachment.eks_cluster.id }
output "node_policy_attachments" { value = [aws_iam_role_policy_attachment.node_worker.id, aws_iam_role_policy_attachment.node_cni.id, aws_iam_role_policy_attachment.node_ecr.id] }
