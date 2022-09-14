
module "shared_vars" {
  source = "../shared_vars"
}

output "iam_profile" {

  value = aws_iam_instance_profile.devops-ci-ec2-profile.id
}

resource "aws_iam_instance_profile" "devops-ci-ec2-profile" {
  name = "ec2_profile-${module.shared_vars.env_suffix}"
  role = aws_iam_role.devops-resources-iam-role.name
}

resource "aws_iam_role" "devops-resources-iam-role" {
  name               = "devops-ci-ssm-role-${module.shared_vars.env_suffix}"
  description        = "The role for the devops resources EC2"
  assume_role_policy = file("assets/ec2_assume_policy.json")

  tags = {
    Name     = "devops-ci-resources-iam-role"
    Owner    = "devops-Engineering"
    Customer = "devops-Engineering"
  }
}

resource "aws_iam_role_policy_attachment" "devops-resources-ssm-policy" {
  role       = aws_iam_role.devops-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "devops-resources-fullacess-policy" {
  role       = aws_iam_role.devops-resources-iam-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}
