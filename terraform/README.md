# Infrastructure as Code (Terraform) — DevOps IA-3

## Overview
This directory contains the HashiCorp Terraform configuration for managing the Microsoft Azure infrastructure supporting the **DevOps IA-3 Academic Project**.

Infrastructure is defined declaratively using the AzureRM provider to ensure reproducible, auditable, and immutable cloud deployments.

---

## Azure Architecture & Resource Hierarchy

| Resource | Resource Name | Azure Region | Description |
| :--- | :--- | :--- | :--- |
| **Resource Group** | `devops-ia3-rg` | `southindia` | Root container for lifecycle governance |
| **Virtual Network** | `devops-ia3-vnet` | `centralindia` | 10.0.0.0/16 private CIDR address space |
| **Subnet** | `devops-ia3-subnet` | `centralindia` | 10.0.1.0/24 subnet for host compute |
| **Public IP** | `devops-ia3-public-ip` | `centralindia` | Static, Standard SKU IPv4 address (`20.219.161.235`) |
| **NSG** | `devops-ia3-nsg` | `centralindia` | Inbound firewall (Port 80 Any, Port 22 Admin Only) |
| **NIC** | `devops-ia3-nic` | `centralindia` | Attached to subnet and public IP |
| **Virtual Machine** | `devops-ia3-vm` | `centralindia` | Ubuntu 22.04 LTS (Standard_B2als_v2) |
| **OS Disk** | `devops-ia3-os-disk` | `centralindia` | Standard_LRS managed disk |

---

## Security Policies & Least Privilege

1. **Inbound HTTP (Port 80):** Permitted from `*` to allow public evaluation of the web dashboard.
2. **Inbound SSH (Port 22):** Strictly restricted to the administrator's public IP address (`admin_ssh_allowed_ip`).
3. **Key-Based Authentication:** Password authentication is disabled. Authentication requires the private key corresponding to `devops_ia3_key.pub`.
4. **Secrets Isolation:** No private keys, passwords, or cloud credentials are stored in Terraform source code or state in version control.

---

## Safe Execution Workflow

### 1. Formatting Check
Verify canonical Terraform formatting:
```bash
terraform fmt -check -recursive
```

### 2. Provider Initialization
Initialize required AzureRM provider plugins:
```bash
terraform init
```

### 3. Syntax & Schema Validation
Validate the syntactic correctness of configuration blocks:
```bash
terraform validate
```

### 4. Safe State Import (Existing Resources)
Because resources were provisioned in Azure, they should be imported rather than recreated:
```bash
# Example imports to reconcile state without recreation:
terraform import azurerm_resource_group.rg /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/devops-ia3-rg
terraform import azurerm_public_ip.public_ip /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/devops-ia3-rg/providers/Microsoft.Network/publicIPAddresses/devops-ia3-public-ip
```

### 5. Plan Execution (Dry Run)
Inspect the proposed execution plan:
```bash
terraform plan
```
> [!IMPORTANT]
> Never run `terraform apply` or `terraform destroy` without reviewing the exact plan. Avoid replacing running production instances.
