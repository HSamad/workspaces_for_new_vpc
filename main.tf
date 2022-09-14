
module "vpc_module" {
  source = "./vpc_module"
}

module "network_module" {
  source  = "./network_module"
  vpcid   = module.vpc_module.vpcid
  vpcname = module.vpc_module.vpcname
}

module "loadbalancer_module" {
  source           = "./loadbalancer_module"
  vpcid            = module.vpc_module.vpcid
  publicsg_id      = module.network_module.publicsg_id
  public_subnet_1_id = module.network_module.public_subnet_1_id
  public_subnet_2_id = module.network_module.public_subnet_2_id

}

module "vpcendpoints_module" {
  source           = "./vpcendpoints_module"
  privatesg_id     = module.network_module.privatesg_id
  publicsg_id      = module.network_module.publicsg_id
  instance_asg     = module.loadbalancer_module.instance_asg
  vpcid            = module.vpc_module.vpcid
  public_subnet_1_id = module.network_module.public_subnet_1_id
  public_subnet_2_id = module.network_module.public_subnet_2_id
}

module "iamrole_module" {
  source = "./iamrole_module"
}

module "autoscaling_module_c" {
  source       = "./autoscaling_module_c"
  publicsg_id  = module.network_module.publicsg_id
  privatesg_id = module.network_module.privatesg_id
  tg_arn       = module.loadbalancer_module.tg_arn
  instance_asg = module.loadbalancer_module.instance_asg
  iam_profile  = module.iamrole_module.iam_profile
  public_subnet_1_id = module.network_module.public_subnet_1_id
  public_subnet_2_id = module.network_module.public_subnet_2_id
}

module "autoscaling_module_java" {
  source       = "./autoscaling_module_java"
  publicsg_id  = module.network_module.publicsg_id
  privatesg_id = module.network_module.privatesg_id
  tg_arn       = module.loadbalancer_module.tg_arn
  instance_asg = module.loadbalancer_module.instance_asg
  iam_profile = module.iamrole_module.iam_profile
  public_subnet_1_id = module.network_module.public_subnet_1_id
  public_subnet_2_id = module.network_module.public_subnet_2_id
}


