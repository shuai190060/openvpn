output "bastion_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "private_ip" {
  value = aws_instance.private_vm.private_ip

}

output "vpn_client_ip" {
  value = aws_instance.vpn_client.public_ip
}

output "client_hostname" {
  value = aws_instance.vpn_client.private_dns
}

output "server_hostname" {
  value = aws_instance.bastion_host.private_dns
}