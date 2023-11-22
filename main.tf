locals {
  ami = "ami-0d92749d46e71c34c"
  instance = "t2.micro"
  key = "pem.file"
  vpc = "vpc-0fd5dd5921c2e8398"
  subnet = "subnet-0ffe545b2119997a5"
  name = "server-2"
}
resource "aws_security_group" "http_access" {
  name        = "security_g"
  description = "Allow HTTP access"
  vpc_id = local.vpc
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webservers" {
  ami = local.ami
  instance_type = local.instance
  security_groups = [aws_security_group.http_access.id]
  subnet_id = local.subnet
  key_name = local.key
  tags = {
    Name = local.name
  }
  provisioner "file" {
    source = "/root/file"
    destination = "/home/ec2-user/file"
  }
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file("/home/ec2-user/pem-file/pem.file.pem")
    timeout = "4m"
  }
  provisioner "remote-exec" {
    inline = ["mkdir folder1","mkdir folder2","mkdir folder3"]
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }
  provisioner "local-exec" {
   command = "echo 'Creation is successful.' >> creation.txt"
 }
 
 provisioner "local-exec" {
   when = destroy
   command = "echo 'Destruction is successful.' >> destruction.txt"
 }
}
 
output "instance_public_ip" {
  value = aws_instance.webservers.public_ip
}
