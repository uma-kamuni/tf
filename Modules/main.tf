module "vpc" {
    source = "./module/VPC"
    vpc_cidr = "10.0.0.0/16"
    public_subnet_cidr = "10.0.1.0/24"
    private_subnet_cidr = "10.0.2.0/24"
    public_az = "eu-north-1a"
    private_az = "eu-north-1b"
    sg_name = "my_security_group"
    http_port = 80
    ssh_port = 22
}

module "ec2" {
    source = "./module/EC2"
    ami = "ami-0aba19e56f3eaec05"
    instance_type = "t3.micro"
    key_name = "account-2"
    sg_id = module.vpc.sg_id
    public_subnet_id = module.vpc.public_subnet_id
    private_subnet_id = module.vpc.private_subnet_id
}