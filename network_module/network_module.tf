module "shared_vars" {
  source = "../shared_vars"
}

variable "vpcid" {}
variable "vpcname" {}

# create public subnet
resource "aws_subnet" "public-subnet-1" {
  # count                   = length(split(",", "${module.shared_vars.public-subnets}"))
  vpc_id                  = var.vpcid
  map_public_ip_on_launch = true
  cidr_block              = module.shared_vars.public-subnet-1-cidr
  availability_zone       = module.shared_vars.az-2a


  tags = {
    # Name = "${var.product}.${var.environment}-public_subnets.${count.index + 1}"
    Name = "Public Subnet 1 ${module.shared_vars.env_suffix}"
  }
}

output "public_subnet_1_id" {
  value = aws_subnet.public-subnet-1.id
}


resource "aws_subnet" "public-subnet-2" {
  # count                   = length(split(",", "${module.shared_vars.public-subnets}"))
  vpc_id                  = var.vpcid
  map_public_ip_on_launch = true
  cidr_block              = module.shared_vars.public-subnet-2-cidr
  availability_zone       = module.shared_vars.az-2b


  tags = {
    # Name = "${var.product}.${var.environment}-public_subnets.${count.index + 1}"
    Name = "Public Subnet 2 ${module.shared_vars.env_suffix}"
  }
}

output "public_subnet_2_id" {
  value = aws_subnet.public-subnet-2.id
}

 
resource "aws_subnet" "private-subnet-1" {
  # count                   = length(split(",", "${module.shared_vars.public-subnets}"))
  vpc_id                  = var.vpcid
  map_public_ip_on_launch = false
  cidr_block              = module.shared_vars.private-subnet-1-cidr
  availability_zone       = module.shared_vars.az-2a


  tags = {
    # Name = "${var.product}.${var.environment}-public_subnets.${count.index + 1}"
    Name = "Private Subnet 1 | App Tier | ${module.shared_vars.env_suffix}"
  }
}

output "private_subnet_1_id" {
  value = aws_subnet.private-subnet-1.id
}

resource "aws_subnet" "private-subnet-2" {
  # count                   = length(split(",", "${module.shared_vars.public-subnets}"))
  vpc_id                  = var.vpcid
  map_public_ip_on_launch = false
  cidr_block              = module.shared_vars.private-subnet-2-cidr
  availability_zone       = module.shared_vars.az-2b


  tags = {
    # Name = "${var.product}.${var.environment}-public_subnets.${count.index + 1}"
    Name = "Private Subnet 2 | App Tier | ${module.shared_vars.env_suffix}"
  }
}

output "private_subnet_2_id" {
  value = aws_subnet.private-subnet-2.id
}

# Creating Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpcid

  tags = {
    # Name = "${var.product}.${var.environment}-gw"
    Name = "CI IGW ${module.shared_vars.env_suffix}"
  }
}

# Public Route Table

resource "aws_route_table" "public-route-table" {
  vpc_id = var.vpcid

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    # Name = "${var.product}.${var.environment}-public_route"
    Name = "Public Route Table ${module.shared_vars.env_suffix}"
  }
}

# Private Route Table

resource "aws_default_route_table" "private-route" {
  default_route_table_id = "${var.vpcname}".default_route_table_id

  tags = {
    # Name = "${var.product}.${var.environment}-private_route"
    Name = "Private Route Table ${module.shared_vars.env_suffix}"
  }
}

#  #Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  # count          = length(split(",", "${module.shared_vars.public-subnets}"))
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  # count          = length(split(",", "${module.shared_vars.public-subnets}"))
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}


 

resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  # count          = length(split(",", "${module.shared_vars.private-subnets}"))
  route_table_id = aws_default_route_table.private-route.id
  subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  # count          = length(split(",", "${module.shared_vars.private-subnets}"))
  route_table_id = aws_default_route_table.private-route.id
  subnet_id      = aws_subnet.private-subnet-2.id

}

# creating public sg
resource "aws_security_group" "devops-public-sg" {
  name        = "devops-public-sg-${module.shared_vars.env_suffix}"
  description = "public sg for ELB ${module.shared_vars.env_suffix}"
  vpc_id      = var.vpcid

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    description = "CI - AWS - Allow - RDP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    description = "CI - AWS - Allow - File Sharing"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "CI - AWS - Allow - SSM"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "ci"
    Owner = "devops-engineering"
  }
}

output "publicsg_id" {
  value = aws_security_group.devops-public-sg.id
}


# creating private sg.
resource "aws_security_group" "devops-private-sg" {
  name        = "devops-private-sg-${module.shared_vars.env_suffix}"
  description = "private sg for ELB ${module.shared_vars.env_suffix}"
  vpc_id      = var.vpcid

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.devops-public-sg.id}"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    description = "CI - AWS - Allow - RDP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "CI - AWS - Allow - SSM"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "CI - AWS - Allow - SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "ci"
    Owner = "devops-engineering"
  }
}

output "privatesg_id" {
  value = aws_security_group.devops-private-sg.id
}
