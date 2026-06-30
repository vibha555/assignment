variable "enabled" { type = bool }
variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "instance_type" { type = string }
variable "tags" { type = map(string) }
