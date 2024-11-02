terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "Domjudge VPC"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    availability_zone_id = "use1-az6"
    cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    availability_zone_id = "use1-az1"
    cidr_block = "10.0.7.0/24"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    availability_zone_id = "use1-az6"
    cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id

 tags = {
   Name = "Internet Gateway for ICPC"
 }
}

resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "Public Route Table for ALB and NAT"
 }
}

resource "aws_route_table_association" "public_subnet_asso" {
 subnet_id      = aws_subnet.public_subnet
 route_table_id = aws_route_table.public_rt.id
}

