provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "web" {
  ami           = "ami-00beae93a2d981137"
  instance_type = "t2.micro"

  tags = {
    Name = "WavesurferApp"
  }

  key_name      = aws_key_pair.deployer.key_name

  security_groups = [aws_security_group.web_sg.name]

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }

  provisioner "file" {
    source      = var.private_key_path
    destination = "/home/ec2-user/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 600 /home/ec2-user/.ssh/id_rsa",
      "sudo yum update -y",
      "sudo yum install -y python3-pip",
      "pip3 install ansible",
      "ansible-playbook -i /home/ec2-user/inventory /home/ec2-user/playbook.yml"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "ansible/"
    destination = "/home/ec2-user/"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
