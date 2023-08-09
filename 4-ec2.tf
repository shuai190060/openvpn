resource "aws_key_pair" "ansible_ec2" {
  key_name   = "ansible_ec2"
  public_key = file("~/.ssh/ansible.pub")

}

resource "aws_instance" "bastion_host" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.public_sg.id]
  associate_public_ip_address = true


  key_name = "ansible_ec2"

  tags = {
    "Name" = "bastion"
  }
}

resource "aws_instance" "private_vm" {
  ami             = "ami-053b0d53c279acc90"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private.id
  security_groups = [aws_security_group.private_sg.id]

  key_name = "ansible_ec2"

  tags = {
    "Name" = "private"
  }
}


# for testing as a vpn client
resource "aws_instance" "vpn_client" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.public_sg.id]
  associate_public_ip_address = true


  key_name = "ansible_ec2"

  tags = {
    "Name" = "vpn_client"
  }
}