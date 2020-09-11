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

#####################
## Custom policies ##
#####################

# S3 credentials bucket access
# Allows the server to read/write api keys to the S3 bucket.
resource "aws_iam_policy" "s3_server_credentials" {

    name = "${var.server_name}-S3-credentials-access"
    path = "/"
    description = "Allow the Rancher server to access the credentials file in the S3 bucket."
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.server_credentials_bucket.id}/keys.txt"
      ]
    }
  ]
}
EOF

}

#############################
## Attach policies to role ##
#############################

# S3 bucket access
resource "aws_iam_policy_attachment" "rancher_server_s3_policy" {

    name = "${var.server_name}_s3_policy"
    policy_arn = "${aws_iam_policy.s3_server_credentials.arn}"
    roles = [ "${aws_iam_role.rancher_server_role.name}" ]
}

