
module "shared_vars" {
  source = "../shared_vars"
}

variable "privatesg_id" {}
variable "publicsg_id" {}

variable "tg_arn" {}
variable "iam_profile" {}
variable "instance_asg" {}

variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}

locals {

  env = terraform.workspace

  root_block_device_size_env = {
    default    = "100"
    staging    = "100"
    production = "100"
  }

  rootblockdevicesize = lookup(local.root_block_device_size_env, local.env)

  root_block_device_type_env = {
    default    = "gp2"
    staging    = "gp2"
    production = "gp2"
  }

  rootblockdevicetype = lookup(local.root_block_device_type_env, local.env)

  root_block_device_termination_env = {
    default    = "true"
    staging    = "true"
    production = "true"
  }

  rootblockdevicetermination = lookup(local.root_block_device_termination_env, local.env)

  ebs_block_device_size_env = {
    default    = "500"
    staging    = "500"
    production = "500"
  }

  ebsblockdevicesize = lookup(local.ebs_block_device_size_env, local.env)

  ebs_block_device_type_env = {
    default    = "gp3"
    staging    = "gp3"
    production = "gp3"
  }

  ebsblockdevicetype = lookup(local.ebs_block_device_type_env, local.env)

  ebs_block_device_termination_env = {
    default    = "true"
    staging    = "true"
    production = "true"
  }

  ebsblockdevicetermination = lookup(local.ebs_block_device_termination_env, local.env)

  ebs_block_device_name_env = {
    default    = "xvdb"
    staging    = "xvdb"
    production = "xvdb"
  }

  ebsblockdevicename = lookup(local.ebs_block_device_name_env, local.env)


  amiid_env = {
    default    = "ami-a0cfeed8"
    staging    = "ami-a0cfeed8"
    production = "ami-a0cfeed8"
  }

  amiid = lookup(local.amiid_env, local.env)

  instancetype_env = {
    default    = "t2.micro"
    staging    = "t3.medium"
    production = "t3.medium"
  }

  instancetype = lookup(local.instancetype_env, local.env)

  keypairname_env = {
    default    = "aws_devops_kp_staging"
    staging    = "aws_devops_kp_staging"
    production = "key_pair_us_west_2"
  }

  keypairname = lookup(local.keypairname_env, local.env)

  asgdesired_env = {
    default    = "1"
    staging    = "1"
    production = "2"
  }

  asgdesired = lookup(local.asgdesired_env, local.env)


  asgmin_env = {
    default    = "1"
    staging    = "1"
    production = "2"
  }

  asgmin = lookup(local.asgmin_env, local.env)


  asgmax_env = {
    default    = "2"
    staging    = "2"
    production = "4"
  }

  asgmax = lookup(local.asgmax_env, local.env)
}

# ec2 instance in public subnet:
# resource "aws_instance" "ci-aws-iac-java-agent" {
#   ami           = local.amiid
#   instance_type = local.instancetype
#   key_name      = local.keypairname
#   subnet_id     = module.shared_vars.publicsubnetid-usw2-az4
#   # vpc_security_group_ids = ["${aws_security_group.terraform_ec2_devops_sg_module.id}"]
#   security_groups      = ["${var.publicsg_id}"]
#   iam_instance_profile = var.iam_profile

#   ebs_optimized = "true"

#   root_block_device {
#     volume_type           = local.rootblockdevicetype
#     volume_size           = local.rootblockdevicesize
#     delete_on_termination = local.rootblockdevicetermination
#   }
#   ebs_block_device {
#     volume_type           = local.ebsblockdevicetype
#     device_name           = local.ebsblockdevicename
#     volume_size           = local.ebsblockdevicesize
#     delete_on_termination = local.ebsblockdevicetermination
#   }

#   tags = {
#     Name        = "ci-aws-iac-java-agent-${module.shared_vars.env_suffix}"
#     Owner       = "devops-Engineering"
#     Environment = "${module.shared_vars.env_suffix}"
#     Customer    = "devops-Engineering"
#   }
# }


resource "aws_launch_configuration" "ci-java-lc" {
  name          = "ci-java-lc-${local.env}"
  image_id      = local.amiid
  instance_type = local.instancetype
  key_name      = local.keypairname
  #   user_data     = file("assets/powershell.txt")
  security_groups = ["${var.instance_asg}", "${var.publicsg_id}"]

  iam_instance_profile = var.iam_profile

  associate_public_ip_address = true

  ebs_optimized = "true"

  root_block_device {
    volume_type           = local.rootblockdevicetype
    volume_size           = local.rootblockdevicesize
    delete_on_termination = local.rootblockdevicetermination
  }
  ebs_block_device {
    volume_type           = local.ebsblockdevicetype
    device_name           = local.ebsblockdevicename
    volume_size           = local.ebsblockdevicesize
    delete_on_termination = local.ebsblockdevicetermination
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ci-java-asg" {

  name                 = "ci-java-asg-${module.shared_vars.env_suffix}"
  max_size             = local.asgmax
  min_size             = local.asgmin
  desired_capacity     = local.asgdesired
  launch_configuration = aws_launch_configuration.ci-java-lc.name
  # vpc_zone_identifier  = ["${module.shared_vars.subnet-1a}","${module.shared_vars.subnet-1b}"]
  vpc_zone_identifier = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]

  tags = [
    {
      "key"                 = "Name"
      "value"               = "ci-java-${module.shared_vars.env_suffix}"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "Environment"
      "value"               = "ci-java-${module.shared_vars.env_suffix}"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "Owner"
      "value"               = "devops-engineering-ci-${module.shared_vars.env_suffix}"
      "propagate_at_launch" = true
    }
  ]
}

resource "aws_autoscaling_attachment" "ci-asa" {
  autoscaling_group_name = aws_autoscaling_group.ci-java-asg.id
  lb_target_group_arn    = var.tg_arn
}
