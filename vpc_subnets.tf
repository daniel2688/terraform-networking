terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Usa la versión más estable para tu caso
    }
  }
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}

# 🔹 Subredes públicas (2)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# 🔸 Subredes privadas (4)
resource "aws_subnet" "private" {
  count             = 4
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# AZs disponibles
data "aws_availability_zones" "available" {}


# resource "aws_s3_bucket" "test" {
#     bucket = "my-test-bucket-danicor2688"
#     tags = {
#         Name = "test-bucket"
#     }

# }

# resource "aws_s3_bucket" "test" {
#   # Puedes dejarlo vacío o agregar parámetros mínimos
# }
