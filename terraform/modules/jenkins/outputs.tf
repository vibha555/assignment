output "public_ip" { value = var.enabled ? aws_instance.jenkins[0].public_ip : null }
