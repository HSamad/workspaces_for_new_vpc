provider "aws" {
  region  = "us-west-2"
  profile = "HSamad"
}

# this project designed for a given default vpc of certain region, with its default subnets and availability zones.
# e.g
# region us-west-2
# vpc default
# subnets default attached to default vpc.
# given azs
# implementation: 
# workspace
# shared vars across modules.
# env specific vars.
# autoscaling
# load balancer.
# iam role and iam profile, attachment of policies to iam role.
# attachment of iam profile with ec2 instances created throught launch configuration.
# vcp endpoints for aws certain services for default given vpc.
