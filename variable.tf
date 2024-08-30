variable "vpcs" {
  type = list(object({
    name = string
    cidr = string
    tags = map(string)
  }))
}

variable "security_group" {
  type = map(list(object({
    type      = string
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  })))
}

variable "subnets" {
  type = map(object({
    name = string
    cidr = string
    vpc  = string
    tags = map(string) # Use map(string) if multiple tags are expected
  }))
}

# variable "dev_count"{
#     type = number
# }

# variable "dev" {
#     type = object({
#         model_type = string
#         os_type = string
#         subnet = string
#         security_group_type = string

#     })
# }

# variable "proxy" {
#     type = object({
#         model_type = string
#         os_type = string
#         subnet = string
#         security_group_type = string

#     })
# }


variable "bastion" {
  type = object({
    model_type          = string
    os_type             = string
    subnet              = string
    security_group_type = string
  })
}