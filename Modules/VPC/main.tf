resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.public_az
    map_public_ip_on_launch = true
    tags = {
        Name = "my_public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.private_az
    tags = {
        Name = "my_private_subnet"
    }
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "my_igw"
    }
}

resource "aws_eip" "my_eip" {
    domain = "vpc"
    tags = {
        Name = "my_eip"
    }
}

resource "aws_nat_gateway" "my_nat_gw" {
    allocation_id = aws_eip.my_eip.id
    subnet_id = aws_subnet.my_public_subnet.id
    tags = {
        Name = "my_nat_gw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}

resource "aws_route_table_association" "public_rt_association" {
    subnet_id = aws_subnet.my_public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}   

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.my_nat_gw.id
    }
}       

resource "aws_route_table_association" "private_rt_association" {
    subnet_id = aws_subnet.my_private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}  


resource "aws_security_group" "my_sg" {
    name = var.sg_name
    description = "my_sg"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "my_sg"
    }
}       