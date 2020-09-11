# Rancher server security group
resource "aws_security_group" "rancher_server_sg" {

    name = "${var.server_name}-Rancher-Server"
    description = "Rules for the Rancher server instance."
    vpc_id = "${var.vpc_id}"

    tags = {
        Name = "${var.server_name}"
        ManagedBy = "terraform"
    }


}

# Incoming HTTP from anywhere
# Nginx will redirect all http traffic to https
resource "aws_security_group_rule" "http_ingress" {

    security_group_id = "${aws_security_group.rancher_server_sg.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


}

# Incoming HTTPS from anywhere
resource "aws_security_group_rule" "https_ingress" {

    security_group_id = "${aws_security_group.rancher_server_sg.id}"
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


}

# Outgoing HTTP to anywhere
resource "aws_security_group_rule" "http_egress" {

    security_group_id = "${aws_security_group.rancher_server_sg.id}"
    type = "egress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


}

# Outgoing HTTPS to anywhere
resource "aws_security_group_rule" "https_egress" {

    security_group_id = "${aws_security_group.rancher_server_sg.id}"
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


}

# Outgoing SSH to anywhere
# Allows configuration of rancher host instances via the UI
resource "aws_security_group_rule" "ssh_egress" {

    security_group_id = "${aws_security_group.rancher_server_sg.id}"
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


}

# Outgoing docker API to anywhere
# Allows configuration of rancher host instances via the UI
resource "aws_security_group_rule" "docker_egress" {

    security_group_id = "${aws_security_group.rancher_server_sg.id}"
    type = "egress"
    from_port = 2376
    to_port = 2376
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


}

# Outgoing mysql
resource "aws_security_group_rule" "mysql_egress" {

    security_group_id = "${aws_security_group.rancher_server_sg.id}"
    type = "egress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


}

output "server_security_group_id" {
    value = "${aws_security_group.rancher_server_sg.id}"
}
