###############
## Variables ##
###############

# Target VPC config
variable "vpc_id" {
    description = "ID of target VPC."
}
variable "vpc_region" {
    description = "Region of the target VPC"
}
variable "vpc_private_subnets" {
    description = "Comma separated list of private subnet ip address ranges."
}
variable "vpc_private_subnet_ids" {
    description = "Comma separated list of private subnet ids."
}

# Server config
variable "server_name" {
    description = "Name of the Rancher server. Best not to include non-alphanumeric characters."
}

variable "server_key" {
    description = "Public key file for the Rancher server instance."
}
variable "server_subnet_id" {
    description = "Public subnet id in which to place the rancher server instance."
}

variable "server_instance_type" {
    description = "EC2 instance type to use for the rancher server."
    default = "t2.micro"
}

variable "server_root_volume_type" {
    default = "gp2"
}
variable "server_root_volume_size" {
    default = "30"
}
variable "server_root_volume_delete_on_terminate" {
    default = true
}

# SSL
variable "ssl_email" {
	description = "E-Mail address to use for Lets Encrypt account."
}

##################
## Misc outputs ##
##################

output "server_hostname" {
	value = "${var.server_hostname}"
}
