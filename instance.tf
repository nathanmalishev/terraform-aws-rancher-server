#############################
## Rancher server instance ##
#############################

# Import the keypair
resource "aws_key_pair" "keypair" {

    key_name   = "${var.server_name}-key"
    public_key = "${file("${var.server_key}")}"


}

# User-data template
data "template_file" "user_data" {

    template = "${file("${path.module}/files/userdata.template")}"

    vars = {

        # VPC config
        vpc_region = "${var.vpc_region}"

        # Server config
        server_version            = "${var.server_version}"
        server_credentials_bucket = "${aws_s3_bucket.server_credentials_bucket.id}"
        server_hostname           = "${var.server_hostname}"

        # SSL certificate
        ssl_email = "${var.ssl_email}"

    }

}

# Create instance
resource "aws_instance" "rancher_server" {

    # Amazon linux
    ami = "${lookup(var.server_ami, var.vpc_region)}"

    # Target subnet - should be public
    subnet_id = "${var.server_subnet_id}"
    associate_public_ip_address = true

    # Security groups
    vpc_security_group_ids = [
        "${aws_security_group.rancher_server_sg.id}"
    ]

    # SSH key
    key_name = "${aws_key_pair.keypair.key_name}"

    # User-data
    # Installs docker, starts containers and performs initial server setup
    user_data = "${data.template_file.user_data.rendered}"

    # Instance profile - sets required permissions to access other aws resources
    iam_instance_profile = "${aws_iam_instance_profile.rancher_server_instance_profile.id}"

    root_block_device {
        volume_type = "${var.server_root_volume_type}"
        volume_size = "${var.server_root_volume_size}"
        delete_on_termination = "${var.server_root_volume_delete_on_terminate}"
    }

    # Misc
    instance_type = "${var.server_instance_type}"

    # Ensure S3 bucket is created first
    depends_on = [
        "aws_s3_bucket.server_credentials_bucket"
    ]

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
