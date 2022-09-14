
module "shared_vars" {
  source = "../shared_vars"
}

variable "vpc-cidr" {
  default = "10.0.0.0/23"
  description = "VPC CIDR Block"
  type = string
}


resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc-cidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  
  tags = {
    Name = "ci-aws-iac-${module.shared_vars.env_suffix}"
  }
}

output "vpcid" {

  value = aws_vpc.vpc.id
}

output "vpcname" {

  value = aws_vpc.vpc
}

