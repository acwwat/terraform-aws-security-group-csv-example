terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.5"
}

provider "aws" {}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "sgcsv-example-vpc-use1"
  }
}

locals {
  sg_rules_csv = csvdecode(file("${path.module}/sg-rules.csv"))
  sg_rules     = { for e in local.sg_rules_csv : "${e.resource_name}-${e.type}-${e.name}" => e }
}

resource "aws_security_group" "db" {
  name        = "sgcsv-example-sg-use1-db"
  description = "Security group for the RDS for MySQL database instance"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name = "sgcsv-example-sg-use1-db"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  for_each                     = { for k, v in local.sg_rules : "${v.name}" => v if v.resource_name == "db" && v.type == "ingress" }
  security_group_id            = aws_security_group.db.id
  cidr_ipv4                    = try(each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null, null)
  prefix_list_id               = try(each.value.prefix_list_id != "" ? each.value.prefix_list_id : null, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null, null)
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "db" {
  for_each                     = { for k, v in local.sg_rules : "${v.name}" => v if v.resource_name == "db" && v.type == "egress" }
  security_group_id            = aws_security_group.db.id
  cidr_ipv4                    = try(each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null, null)
  prefix_list_id               = try(each.value.prefix_list_id != "" ? each.value.prefix_list_id : null, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null, null)
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
}

resource "aws_security_group" "web" {
  name        = "sgcsv-example-sg-use1-web"
  description = "Security group for the EC2 web server instance"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name = "sgcsv-example-sg-use1-web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web" {
  for_each                     = { for k, v in local.sg_rules : "${v.name}" => v if v.resource_name == "web" && v.type == "ingress" }
  security_group_id            = aws_security_group.web.id
  cidr_ipv4                    = try(each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null, null)
  prefix_list_id               = try(each.value.prefix_list_id != "" ? each.value.prefix_list_id : null, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null, null)
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "web" {
  for_each                     = { for k, v in local.sg_rules : "${v.name}" => v if v.resource_name == "web" && v.type == "egress" }
  security_group_id            = aws_security_group.web.id
  cidr_ipv4                    = try(each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null, null)
  prefix_list_id               = try(each.value.prefix_list_id != "" ? each.value.prefix_list_id : null, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null, null)
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
}

resource "aws_security_group" "alb" {
  name        = "sgcsv-example-sg-use1-alb"
  description = "Security group for the ALB"
  vpc_id      = aws_vpc.this.id
  tags = {
    Name = "sgcsv-example-sg-use1-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  for_each                     = { for k, v in local.sg_rules : "${v.name}" => v if v.resource_name == "alb" && v.type == "ingress" }
  security_group_id            = aws_security_group.alb.id
  cidr_ipv4                    = try(each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null, null)
  prefix_list_id               = try(each.value.prefix_list_id != "" ? each.value.prefix_list_id : null, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null, null)
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  for_each                     = { for k, v in local.sg_rules : "${v.name}" => v if v.resource_name == "alb" && v.type == "egress" }
  security_group_id            = aws_security_group.alb.id
  cidr_ipv4                    = try(each.value.cidr_ipv4 != "" ? each.value.cidr_ipv4 : null, null)
  cidr_ipv6                    = try(each.value.cidr_ipv6 != "" ? each.value.cidr_ipv6 : null, null)
  prefix_list_id               = try(each.value.prefix_list_id != "" ? each.value.prefix_list_id : null, null)
  referenced_security_group_id = try(each.value.referenced_security_group_id != "" ? each.value.referenced_security_group_id : null, null)
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
}
