resource "aws_vpc" "asr" {
    cidr_block = "10.0.0.0/16"
    tags = {
      name="asr_vpc"
    }
    
 
}
resource "aws_subnet" "asr_local" {
    vpc_id = aws_vpc.asr.id
    cidr_block = "10.0.0.0/24"

    tags = {
        name="asr_subnet"
    }
}
resource "aws_internet_gateway" "asr_local" {
    vpc_id = aws_vpc.asr.id-

    tags = {
      name="asr_ig"
    }
  
}
resource "aws_route_table" "asr_local" {
    vpc_id = aws_vpc.asr.id
    
route {
    cidr_block="0.0.0.0/0"
    gateway_id = aws_internet_gateway.asr_local.id

}
}
resource "aws_route_table_association" "asr_local" {
    subnet_id = aws_subnet.asr_local.id
    route_table_id = aws_route_table.asr_local.id


}
  
resource "aws_security_group" "asr_sg" {
    name = "allow all traffic"
    vpc_id = aws_vpc.asr.id

    tags = {
      Name="asr-sg"
    }  

    ingress {
    description = "Allow SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
     egress {
      description = "Allow all traffic out"
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "name" {
    ami = "ami-07b2fe5d6ba52171e"
    key_name = "awskey"
    instance_type = "t2.micro"

    tags = {
      Name="Terraform EC2"

    }
  
}
resource "aws_s3_bucket" "name" {
    bucket = "asr1432"


}
resource "aws_subnet" "pvt" {
    vpc_id = aws_vpc.asr.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "pvt-subnet"

    }
  
}
resource "aws_eip" "nat" {
    


  
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.asr_local.id

    tags = {
      Name="nat"
    }
  
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.asr.id
    tags = {
      Name="pvt-route"
    }
  
}
resource "aws_route" "aws_nat_gateway" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id

  
}
resource "aws_route_table_association" "pvt" {
    subnet_id = aws_subnet.pvt.id
    route_table_id = aws_route_table.private.id

    
}
resource "aws_instance" "pvt_server" {
    ami = "ami-071d6b6bbb231289b"
    instance_type = "t2.micro"
    key_name = "awskey"
    subnet_id = aws_subnet.pvt.id


    tags = {
        Name = "pvt server"
    }

  
}
