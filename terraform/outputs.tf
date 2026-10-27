output "resource_group_name" {
  description = "The name of the Azure resource group"
  value       = azurerm_resource_group.rg.name
}

output "vm_name" {
  description = "Name of the Azure Linux Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_size" {
  description = "Compute SKU for the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.size
}

output "public_ip_address" {
  description = "Static Public IPv4 address attached to the VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "private_ip_address" {
  description = "Private IP address assigned to the VM NIC"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "ssh_connection_string" {
  description = "Command string to connect to the VM via SSH"
  value       = "ssh -i ~/.ssh/devops_ia3_key ${var.admin_username}@${azurerm_public_ip.public_ip.ip_address}"
}

output "web_application_url" {
  description = "Public HTTP URL of the deployed web application"
  value       = "http://${azurerm_public_ip.public_ip.ip_address}"
}
