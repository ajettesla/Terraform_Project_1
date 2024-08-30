locals {
  tags = {
    Mangedby = "Teja"
    Owner    = "Poorna"
    Project  = "NSO"
  }
}

resource "aws_vpc" "this" {

  count      = length(var.vpcs)
  cidr_block = var.vpcs[count.index].cidr
  tags       = merge(var.vpcs[count.index].tags, local.tags)

}

resource "aws_subnet" "all" {
  for_each = var.subnets
  vpc_id = element(
    [for vpc in aws_vpc.this : vpc.id],
    index([for vpc in var.vpcs : vpc.name], each.value.vpc)
  )
  map_public_ip_on_launch = startswith(each.value.tags["Name"], "public")

  cidr_block = each.value.cidr
  tags       = merge(each.value.tags, local.tags)
}


resource "aws_internet_gateway" "this" {
  count = length(var.vpcs)

  vpc_id = aws_vpc.this[count.index].id

  tags = merge({ Name = "IG-${count.index}" }, local.tags)
}

resource "aws_route_table" "all" {
  count  = length(var.vpcs)
  vpc_id = aws_vpc.this[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[count.index].id
  }
  tags = merge({ Name = "route_table-${count.index}" }, local.tags)

}

resource "aws_route_table_association" "all" {
  count          = length(var.vpcs)
  subnet_id      = aws_subnet.all["public_${count.index + 1}"].id
  route_table_id = aws_route_table.all[count.index].id
}

resource "aws_security_group" "sg_public" {
  count  = length(var.vpcs)
  vpc_id = aws_vpc.this[count.index].id
  tags   = merge({ Name = "sg_public" }, local.tags)
}


resource "aws_security_group" "sg_private" {
  count  = length(var.vpcs)
  vpc_id = aws_vpc.this[count.index].id
  tags   = merge({ Name = "sg_private" }, local.tags)
}


resource "aws_security_group_rule" "external_rules" {
  count             = length(var.security_group["external_sg"])
  security_group_id = aws_security_group.sg_public[0].id
  type              = var.security_group["external_sg"][count.index].type
  from_port         = var.security_group["external_sg"][count.index].from_port
  to_port           = var.security_group["external_sg"][count.index].to_port
  protocol          = var.security_group["external_sg"][count.index].protocol
  cidr_blocks       = [var.security_group["external_sg"][count.index].cidr]
}



resource "aws_security_group_rule" "internal_rules" {
  count             = length(var.security_group["internal_sg"])
  security_group_id = aws_security_group.sg_private[0].id
  type              = var.security_group["internal_sg"][count.index].type
  from_port         = var.security_group["internal_sg"][count.index].from_port
  to_port           = var.security_group["internal_sg"][count.index].to_port
  protocol          = var.security_group["internal_sg"][count.index].protocol
  cidr_blocks       = [var.security_group["internal_sg"][count.index].cidr]
}
