variable "privatesg_id" {}
variable "publicsg_id" {}
variable "instance_asg" {}
variable "vpcid" {}
variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}
# ["${var.public_subnet_1_id}","${var.public_subnet_2_id}"] 

module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_vpc_endpoint" "ci-ssm" {
  vpc_id            = var.vpcid
  service_name      = "com.amazonaws.us-west-2.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = ["${var.privatesg_id}", "${var.publicsg_id}", "${var.instance_asg}"]
  # subnet_ids = [
  #   "${module.shared_vars.subnet-1a}",
  #   "${module.shared_vars.subnet-1b}",
  #   "${module.shared_vars.subnet-1c}",
  # ]
  subnet_ids = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]
  # private_dns_enabled = true


  tags = {
    Environment = "ci-vpcendpoints-ec2-${module.shared_vars.env_suffix}"
    Name        = "ci-${module.shared_vars.env_suffix}"
    Owner       = "devops-engineering"
  }

}

resource "aws_vpc_endpoint" "ci-ssmmessages" {
  vpc_id            = var.vpcid
  service_name      = "com.amazonaws.us-west-2.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = ["${var.privatesg_id}", "${var.publicsg_id}", "${var.instance_asg}"]
  # subnet_ids = [
  #   "${module.shared_vars.subnet-1a}",
  #   "${module.shared_vars.subnet-1b}",
  #   "${module.shared_vars.subnet-1c}",
  # ]
  subnet_ids = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]
  # private_dns_enabled = true
  tags = {
    Environment = "ci-vpcendpoints-ec2-${module.shared_vars.env_suffix}"
    Name        = "ci-${module.shared_vars.env_suffix}"
    Owner       = "devops-engineering"
  }

}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpcid
  service_name = "com.amazonaws.us-west-2.s3"

  tags = {
    Environment = "ci-vpcendpoints-s3-${module.shared_vars.env_suffix}"
    Name        = "ci-${module.shared_vars.env_suffix}"
    Owner       = "devops-engineering"
  }

}

resource "aws_vpc_endpoint" "ci-ec2" {
  vpc_id            = var.vpcid
  service_name      = "com.amazonaws.us-west-2.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = ["${var.privatesg_id}", "${var.publicsg_id}", "${var.instance_asg}"]
  # subnet_ids = [
  #   "${module.shared_vars.subnet-1a}",
  #   "${module.shared_vars.subnet-1b}",
  #   "${module.shared_vars.subnet-1c}",
  # ]
  subnet_ids = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]
  # private_dns_enabled = true
  tags = {
    Environment = "ci-vpcendpoints-ec2-${module.shared_vars.env_suffix}"
    Name        = "ci-${module.shared_vars.env_suffix}"
    Owner       = "devops-engineering"
  }

}

resource "aws_vpc_endpoint" "ci-ec2messages" {
  vpc_id            = var.vpcid
  service_name      = "com.amazonaws.us-west-2.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = ["${var.privatesg_id}", "${var.publicsg_id}", "${var.instance_asg}"]
  # subnet_ids = [
  #   "${module.shared_vars.subnet-1a}",
  #   "${module.shared_vars.subnet-1b}",
  #   "${module.shared_vars.subnet-1c}",
  # ]
  subnet_ids = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]
  # private_dns_enabled = true
  tags = {
    Environment = "ci-vpcendpoints-ec2-${module.shared_vars.env_suffix}"
    Name        = "ci-${module.shared_vars.env_suffix}"
    Owner       = "devops-engineering"
  }

}

