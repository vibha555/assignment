bucket         = "vikash-eks-terraform-state"
key            = "eks/dev/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "terraform-locks"
encrypt        = true
