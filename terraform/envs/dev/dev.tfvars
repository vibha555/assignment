aws_region           = "ap-south-1"
project_name         = "hospital"
environment          = "dev"
vpc_cidr             = "10.10.0.0/16"
public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
cluster_version      = "1.30"
node_instance_types  = ["t3.micro"]
desired_size         = 1
min_size             = 1
max_size             = 1

