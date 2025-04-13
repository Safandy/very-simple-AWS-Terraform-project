resource "aws_s3_bucket" "my-private-documentssandy-bucket" {
  bucket = "my-private-documentssandy-bucket"  # Replace with a unique bucket name
 
  tags = {
    Name = "PrivateDocumentBucket"
  }
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my-private-documentssandy-bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.ec2_s3_role.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.my-private-documentssandy-bucket.arn}/*"
    }
  ]
}
EOF
}

# IAM Role for EC2 Instances
resource "aws_iam_role" "ec2_s3_role" {
  name = "EC2S3UploadRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = "EC2S3UploadRole"
  }
}
/*
# IAM Policy to Allow S3 Access
resource "aws_iam_policy" "s3_access_policy" {
  name = "S3UploadPolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.my-private-documentssandy-bucket.arn}/*"
    }
  ]
}
EOF
}

# Attach the IAM Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Instance Profile for EC2 Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2S3InstanceProfile"
  role = aws_iam_role.ec2_s3_role.name
}
*/
# Attach a policy to the AmazonSSMRoleForInstancesQuickSetup
resource "aws_iam_policy" "ssm_s3_access_policy" {
  name        = "AmazonSSMRoleS3AccessPolicy"
  description = "Policy to allow AmazonSSMRoleForInstancesQuickSetup access to S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.my-private-documentssandy-bucket.arn}",
        "${aws_s3_bucket.my-private-documentssandy-bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

# Attach the policy to the AmazonSSMRoleForInstancesQuickSetup role
resource "aws_iam_policy_attachment" "attach_ssm_s3_policy" {
  name       = "AmazonSSMRolePolicyAttachment"
  roles      = ["AmazonSSMRoleForInstancesQuickSetup"]
  policy_arn = aws_iam_policy.ssm_s3_access_policy.arn
}