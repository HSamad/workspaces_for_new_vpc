module "shared_vars" {
  source = "../shared_vars"
}

variable "vpcid" {}
variable "publicsg_id" {}
variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}

# outputs: "public_subnet_1_id"  "public_subnet_2_id"  "private-subnet-1"  "private-subnet-2"

resource "aws_lb" "ci-aws-lb" {
  name               = "ci-aws-lb-${module.shared_vars.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ci-lb-asg.id]
  subnets            = ["${var.public_subnet_1_id}", "${var.public_subnet_2_id}"]
}

resource "aws_lb_listener" "ci-listener" {
  load_balancer_arn = aws_lb.ci-aws-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ci-tg.arn
  }
}

resource "aws_lb_target_group" "ci-tg" {
  name     = "ci-tg-${module.shared_vars.env_suffix}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpcid
  lifecycle {
    ignore_changes  = [tags["BuildUser"]]
    prevent_destroy = false
  }
}


output "tg_arn" {
  value = aws_lb_target_group.ci-tg.arn
}


resource "aws_security_group" "ci-instance-asg" {
  name = "ci-instance-asg-${module.shared_vars.env_suffix}"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ci-lb-asg.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ci-lb-asg.id]
  }

  vpc_id = var.vpcid
}

output "instance_asg" {
  value = aws_security_group.ci-instance-asg.id
}

resource "aws_security_group" "ci-lb-asg" {
  name = "ci-lb-asg-${module.shared_vars.env_suffix}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpcid
}