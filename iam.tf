##########################################
## Rancher server instance profile/role ##
##########################################

# Rancher server instance profile
resource "aws_iam_instance_profile" "rancher_server_instance_profile" {

    name = "${var.server_name}-instance-profile"
    role = "${aws_iam_role.rancher_server_role.name}"

}

# Rancher server role
resource "aws_iam_role" "rancher_server_role" {

    name = "${var.server_name}-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF


}


