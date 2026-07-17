variable "network_info" {
  type = object({
    name = string
    cidr = string
  })
  description = "vpc info"
  default = {
    name = "main"
    cidr = "10.0.0.0/16"
  }
}
variable "availability_zones" {
  description = "available zones"
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "public_subnet_cidrs" {
  description = "public subnet cidr range"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "private_subnet_cidrs"
  type = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "role_name" {
  type = string
  description = "role for eks cluster"
  default = "eks_cluster_role"
}


variable "cluster_name" {
  type = string
  default = "main"
}



variable "node_group" {
  type = map(object({
    node_group_name = string
    instance_type = list(string)
    capacity_type = string
    scaling_info = object({
      desired_size = number
      max_size = number
      min_size = number
    })

  }))
  default = {
    general = {
      node_group_name = "main_ng"
      instance_type = ["t3.medium"]
      capacity_type = "ON_DEMAND"
      scaling_info = {
        desired_size = 2
        max_size = 4
        min_size = 1
      }
    }
  }
 
 
}