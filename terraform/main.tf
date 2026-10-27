# ==============================================================================
# DevOps IA-3: Declarative Azure Infrastructure Management with Terraform
# Author: Francis | Project: DevOps IA-3 Academic Project
# ==============================================================================

# 1. Existing Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.project_tags
}

# 2. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
  tags                = var.project_tags
}

# 3. Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

# 4. Public IP (Static, Standard SKU)
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.project_tags
}

# 5. Network Security Group (NSG) with Restrictive Security Rules
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.project_tags

  # Allow Public HTTP Inbound on TCP Port 80 for Academic Demonstration
  security_rule {
    name                       = "Allow-HTTP-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Strictly Restrict SSH Port 22 to Administrator Public IP Only
  security_rule {
    name                       = "Allow-SSH-Inbound-AdminOnly"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_ssh_allowed_ip
    destination_address_prefix = "*"
  }
}

# 6. Network Interface (NIC)
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.resources_location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.project_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# 7. Associate NIC with NSG
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 8. Ubuntu 22.04 LTS Virtual Machine (Host)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resources_location
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = var.project_tags

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    name                 = "devops-ia3-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
