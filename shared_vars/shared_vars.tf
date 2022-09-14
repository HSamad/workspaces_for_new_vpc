

# private-subnet-1a private-subnet-1b

output "private-subnet-1-cidr" {

  value = local.private-subnet-1-cidr
}

output "private-subnet-2-cidr" {

  value = local.private-subnet-2-cidr
}

output "public-subnet-1-cidr" {

  value = local.public-subnet-1-cidr
}

output "public-subnet-2-cidr" {

  value = local.public-subnet-2-cidr
}

output "az-2a" {

  value = local.az-2a
}

output "az-2b" {

  value = local.az-2b
}

output "az-2c" {

  value = local.az-2c
}
output "az-2d" {

  value = local.az-2d
}

output "subnet-1a" {

  value = local.subnet-1a
}

output "subnet-1b" {

  value = local.subnet-1b
}

output "subnet-1c" {

  value = local.subnet-1c
}


# output "public-subnets" {

#   value = local.public-subnets
# }

# output "private-subnets" {

#   value = local.private-subnets
# }

output "azs" {

  value = local.azs
}

output "env_suffix" {

  value = local.env_suffix
}

locals {

  env = terraform.workspace
  # vpcids, default vpc for N.CA for all 3 envs. You may choose your own.
  # region = "us-west-1"
  env_suffix_env = {
    default    = "staging"
    staging    = "staging"
    production = "production"

  }

  env_suffix = lookup(local.env_suffix_env, local.env)



  # public_subnets_env = {
  #   default    = "10.0.0.0/25,10.0.0.128/25"
  #   staging    = "10.0.0.0/25,10.0.0.128/25"
  #   production = "10.0.0.0/25,10.0.0.128/25"
  # }

  # public-subnets = lookup(local.public_subnets_env, local.env)

  public_subnet_1_cidr_env = {
    default    = "10.0.0.0/25"
    staging    = "10.0.0.0/25"
    production = "10.0.0.0/25"
  }

  public-subnet-1-cidr = lookup(local.public_subnet_1_cidr_env, local.env)

  public_subnet_2_cidr_env = {
    default    = "10.0.0.128/25"
    staging    = "10.0.0.128/25"
    production = "10.0.0.128/25"
  }

  public-subnet-2-cidr = lookup(local.public_subnet_2_cidr_env, local.env)


  # private_subnets_env = {
  #   default    = "10.0.1.0/25,10.0.1.128/25"
  #   staging    = "10.0.1.0/25,10.0.1.128/25"
  #   production = "10.0.1.0/25,10.0.1.128/25"
  # }

  # private-subnets = lookup(local.private_subnets_env, local.env)


  private_subnet_1_cidr_env = {
    default    = "10.0.1.0/25"
    staging    = "10.0.1.0/25"
    production = "10.0.1.0/25"
  }

  private-subnet-1-cidr = lookup(local.private_subnet_1_cidr_env, local.env)

  private_subnet_2_cidr_env = {
    default    = "10.0.1.128/25"
    staging    = "10.0.1.128/25"
    production = "10.0.1.128/25"
  }

  private-subnet-2-cidr = lookup(local.private_subnet_2_cidr_env, local.env)

  azs_env = {
    default    = "us-west-2a,us-west-2b"
    staging    = "us-west-2a,us-west-2b"
    production = "us-west-2a,us-west-2b"
  }

  azs = lookup(local.azs_env, local.env)

  subnet_1a_env = {
    default    = "subnet-0e508c7a8c9c878c4"
    staging    = "subnet-0e508c7a8c9c878c4"
    production = "subnet-0e508c7a8c9c878c4"
  }

  subnet-1a = lookup(local.subnet_1a_env, local.env)

  subnet_1b_env = {
    default    = "subnet-073c4759425e7da4b"
    staging    = "subnet-073c4759425e7da4b"
    production = "subnet-073c4759425e7da4b"
  }

  subnet-1b = lookup(local.subnet_1b_env, local.env)

  subnet_1c_env = {
    default    = "subnet-036b1106ba88b487a"
    staging    = "subnet-036b1106ba88b487a"
    production = "subnet-036b1106ba88b487a"
  }

  subnet-1c = lookup(local.subnet_1c_env, local.env)


  az_2a_env = {
    default    = "us-west-2a"
    staging    = "us-west-2a"
    production = "us-west-2a"
  }

  az-2a = lookup(local.az_2a_env, local.env)

  az_2b_env = {
    default    = "us-west-2b"
    staging    = "us-west-2b"
    production = "us-west-2b"
  }

  az-2b = lookup(local.az_2b_env, local.env)

  az_2c_env = {
    default    = "us-west-2c"
    staging    = "us-west-2c"
    production = "us-west-2c"
  }

  az-2c = lookup(local.az_2c_env, local.env)

  az_2d_env = {
    default    = "us-west-2d"
    staging    = "us-west-2d"
    production = "us-west-2d"
  }

  az-2d = lookup(local.az_2d_env, local.env)

}
