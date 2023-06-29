variable "resource_group_name" {
  description = "Name of the resource group to create the resources in."
  default = "funny-resource-group"
}

variable "location" {
  description = "Azure location to create the resources in."
  default = "East US"
}

variable "vm_name" {
  description = "Name of the virtual machine."
  default = "example-vm"
}

variable "vm_size" {
  description = "Azure virtual machine size."
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Username for the virtual machine administrator."
  default = "adminuser"
}

variable "admin_password" {
  description = "Password for the virtual machine administrator."
  default = "......." #You can use Terraform secret to secure this
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.vm_name}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name

   depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.vm_name}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

   depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_public_ip" "pip" {
  name                = "pip-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"

   depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow_rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

   depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

   depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id

 depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  computer_name  = var.vm_name
  admin_username = var.admin_username
  admin_password = var.admin_password
}

output "public_ip_address" {
  value       = azurerm_public_ip.pip.ip_address
  description = "The public IP address of the Windows Server 2016 virtual machine."
}

output "vm_fqdn" {
  value       = azurerm_public_ip.pip.fqdn
  description = "The fully qualified domain name of the Windows Server 2016 virtual machine."
}
