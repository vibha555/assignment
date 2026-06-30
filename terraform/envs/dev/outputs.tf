output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "vpc_id" { value = module.vpc.vpc_id }
output "ecr_repository_url" { value = module.ecr.repository_url }
output "alb_dns_name" { value = module.alb.alb_dns_name }
output "jenkins_public_ip" { value = module.jenkins.public_ip }
