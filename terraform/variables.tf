variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "devops-ia3-rg"
}

variable "resource_group_location" {
  description = "Location of the existing Resource Group"
  type        = string
  default     = "southindia"
}

variable "resources_location" {
  description = "Location for the infrastructure resources"
  type        = string
  default     = "centralindia"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "devops-ia3-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
  default     = "devops-ia3-subnet"
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_name" {
  description = "Name of the Public IP resource"
  type        = string
  default     = "devops-ia3-public-ip"
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
  default     = "devops-ia3-nsg"
}

variable "nic_name" {
  description = "Name of the Network Interface"
  type        = string
  default     = "devops-ia3-nic"
}

variable "vm_name" {
  description = "Name of the Linux Virtual Machine"
  type        = string
  default     = "devops-ia3-vm"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B2als_v2"
}

variable "admin_username" {
  description = "Administrator username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Local path to the SSH public key"
  type        = string
  default     = "~/.ssh/devops_ia3_key.pub"
}

variable "admin_ssh_allowed_ip" {
  description = "Public IPv4 address allowed for inbound SSH access"
  type        = string
  default     = "14.139.187.145"
}

variable "project_tags" {
  description = "Common resource tags for academic project governance"
  type        = map(string)
  default = {
    Project     = "DevOps_IA3"
    Environment = "Academic"
    ManagedBy   = "Terraform"
    Course      = "DevOps-IA3"
  }
}
