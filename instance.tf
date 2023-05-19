resource "aws_instance" "my_instance_manage_node" {
  ami       = "ami-0c4f7023847b90238"
  instance_type = "t2.medium"
  key_name = "student.4-vm-key"
  vpc_security_group_ids = [aws_security_group.my_sg.id ]
  subnet_id = aws_subnet.my_public_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "student.4-kube-vm"
  }
}
resource "local_file" "inventory" {
  filename = "/etc/ansible/hosts"
  content  = <<EOF
    ${aws_instance.my_instance_manage_node.public_ip}
  EOF
  depends_on = [aws_instance.my_instance_manage_node]
}
resource "time_sleep" "wait_60_seconds" {
  depends_on = [local_file.inventory]

  create_duration = "60s"
}
resource "null_resource" "ansible"{
  provisioner "local-exec" {
    command = "ansible all -m ping --private-key='~/terraform_base/keys/student.4-vm-key'"
    environment = {
     ANSIBLE_HOST_KEY_CHECKING = "false"
    }
  }
  depends_on = [time_sleep.wait_60_seconds]
}
resource "null_resource" "playbook" {
  provisioner "local-exec" {
      command = "ansible-playbook ~/kuber-ansible/docker-kubernetes.yml --private-key='~/terraform_base/keys/student.4-vm-key'"
     environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
  depends_on = [null_resource.ansible]
}
