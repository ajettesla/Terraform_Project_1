locals {
  ami_map = {
    "ubuntu"       = data.aws_ami.ubuntu.id
    "amazon-linux" = data.aws_ami.amazon_linux.id
  }
}


resource "aws_instance" "bastion_machine" {
  ami           =  local.ami_map[var.bastion.os_type]
  instance_type = var.bastion.model_type

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  subnet_id              = aws_subnet.all[var.bastion.subnet].id
  vpc_security_group_ids = [aws_security_group.sg_public[0].id]

  tags = merge({ Name = "bastion" }, local.tags)
}


