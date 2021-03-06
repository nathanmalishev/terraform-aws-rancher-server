#############################
## Rancher server instance ##
#############################

# Import the keypair
resource "aws_key_pair" "keypair" {

    key_name   = "${var.server_name}-key"
    public_key = "${file("${var.server_key}")}"


}

# Create instance
resource "aws_instance" "rancher_server" {

    user_data = templatefile(
      join("/", [path.module, "./files/userdata.template"]),
      {
        docker_version = var.docker_version
        username       = local.node_username
      }
    )
    # Amazon linux
    ami           = data.aws_ami.ubuntu.id

    # Target subnet - should be public
    subnet_id = "${var.server_subnet_id}"
    associate_public_ip_address = true

    # Security groups
    vpc_security_group_ids = [
        "${aws_security_group.rancher_server_sg.id}"
    ]

    # SSH key
    key_name = "${aws_key_pair.keypair.key_name}"

    # Instance profile - sets required permissions to access other aws resources
    iam_instance_profile = "${aws_iam_instance_profile.rancher_server_instance_profile.id}"

    root_block_device {
        volume_type = "${var.server_root_volume_type}"
        volume_size = "${var.server_root_volume_size}"
        delete_on_termination = "${var.server_root_volume_delete_on_terminate}"
    }

    # Misc
    instance_type = "${var.server_instance_type}"


    tags = {
        Name = "${var.server_name}"
        ManagedBy = "terraform"
    }


}

output "server_public_ip" {
    value = "${aws_instance.rancher_server.public_ip}"
}

output "server_keyname" {
    value = "${aws_key_pair.keypair.key_name}"
}
output "server_id" {
    value = "${aws_instance.rancher_server.id}"
}
