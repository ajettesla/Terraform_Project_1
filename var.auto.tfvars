vpcs = [
  {
    name = "vpc_1"
    cidr = "10.0.0.0/16"
    tags = { Name = "vpc_1" }
  }
]

subnets = {
  default = {
    name = "default_public"
    cidr = "10.0.0.0/24"
    vpc  = "vpc_1"
    tags = { Name = "public_subnet_default" }
  }
  private_1 = {
    name = "private_1"
    cidr = "10.0.1.0/24"
    vpc  = "vpc_1"
    tags = { Name = "private_subnet" }
  }
  public_1 = {
    name = "public_1"
    cidr = "10.0.2.0/24"
    vpc  = "vpc_1"
    tags = { Name = "public_subnet" }
  }
}

security_group = {
  internal_sg = [
    { name = "rule1_ingress", type = "ingress", from_port = 1, to_port = 65535, protocol = "tcp", cidr = "10.0.0.0/16" },
    { name = "rule1_egress", type = "egress", from_port = 1, to_port = 65535, protocol = "tcp", cidr = "10.0.0.0/16" }
  ]
  external_sg = [
    {
      name      = "http_ingress", # Add names for clarity
      cidr      = "0.0.0.0/0",
      from_port = 80,
      protocol  = "tcp",
      to_port   = 80,
      type      = "ingress"
    },
    {
      name      = "ssh_ingress", # Add names for clarity
      cidr      = "0.0.0.0/0",
      from_port = 22,
      protocol  = "tcp",
      to_port   = 22,
      type      = "ingress"
    },
    {
      name      = "egress_rule", # Add names for clarity
      cidr      = "0.0.0.0/0",
      from_port = 1,
      protocol  = "tcp",
      to_port   = 65535, # Changed to full port range
      type      = "egress"
    }
  ]
}

bastion = {
  model_type          = "t3.micro"
  os_type             = "amazon-linux"
  subnet              = "public_1"
  security_group_type = "external_rules"
}