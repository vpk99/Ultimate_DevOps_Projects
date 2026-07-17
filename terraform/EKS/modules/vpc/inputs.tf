


variable "network_info" {
  type = object({
    name = string
    cidr = string
  })
  description = "vpc info"
  
}

variable "availability_zones" {
  description = "available zones"
  type = list(string)
}

variable "public_subnet_cidrs" {
  description = "public subnet cidr range"
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = "private_subnet_cidrs"
  type = list(string)
}