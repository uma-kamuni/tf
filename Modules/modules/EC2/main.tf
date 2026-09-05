resource "aws_instance" "public_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [var.sg_id]
    subnet_id = var.public_subnet_id
    associate_public_ip_address = true
    tags = {
        Name = "public_instance"
    
    }
    user_data = file("/root/tf/Modules/EC2/user_data.sh")
}

resource "aws_instance" "private_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [var.sg_id]
    subnet_id = var.private_subnet_id
    tags = {
        Name = "private_instance"
    
    }
    user_data = file("/root/tf/Modules/modules/EC2/user_data.sh")
}