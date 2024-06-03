variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

# Authorization Azure
provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "weatherapp" {
  name     = "weatherapp-resource"
  location = "West Europe"
}

resource "azurerm_virtual_network" "weatherapp" {
  name                = "network-weatherapp"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.weatherapp.location
  resource_group_name = azurerm_resource_group.weatherapp.name
}

resource "azurerm_subnet" "weatherapp" {
  name                 = "subnet-weatherapp"
  resource_group_name  = azurerm_resource_group.weatherapp.name
  virtual_network_name = azurerm_virtual_network.weatherapp.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "weatherapp" {
  name                = "pip-weatherapp"
  location            = azurerm_resource_group.weatherapp.location
  resource_group_name = azurerm_resource_group.weatherapp.name
  allocation_method   = "Static"
  domain_name_label   = "weatherapp-hz"  # Adding DNS
}

# Security group - Firewall
resource "azurerm_network_security_group" "weatherapp" {
  name                = "nsg-weatherapp"
  location            = azurerm_resource_group.weatherapp.location
  resource_group_name = azurerm_resource_group.weatherapp.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "weatherapp" {
  name                = "nic-weatherapp"
  location            = azurerm_resource_group.weatherapp.location
  resource_group_name = azurerm_resource_group.weatherapp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.weatherapp.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.10"
    public_ip_address_id          = azurerm_public_ip.weatherapp.id
  }
}
# Associate security group to network interface
resource "azurerm_network_interface_security_group_association" "weatherapp" {
  network_interface_id      = azurerm_network_interface.weatherapp.id
  network_security_group_id = azurerm_network_security_group.weatherapp.id
}

# VM config
resource "azurerm_virtual_machine" "weatherapp" {
  name                  = "weatherapp-hz"
  location              = azurerm_resource_group.weatherapp.location
  resource_group_name   = azurerm_resource_group.weatherapp.name
  network_interface_ids = [azurerm_network_interface.weatherapp.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "C"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

# SSH RSA Config
    os_profile {
    computer_name  = "weatherapp-hz"
    admin_username = "weatherapp-hz"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/weatherapp-hz/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }
}

output "vm_id" {
  value = azurerm_virtual_machine.weatherapp.id
}

output "public_ip_address" {
  value = azurerm_public_ip.weatherapp.ip_address
}

output "public_ip_dns" {
  value = "${azurerm_public_ip.weatherapp.domain_name_label}.westeurope.cloudapp.azure.com"
}