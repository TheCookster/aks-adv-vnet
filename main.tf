provider "azurerm" {
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "test" {
  name     = "${var.prefix}-k8s-rg"
  location = "${var.location}"
}

resource azurerm_network_security_group "test_advanced_network" {
  name                = "akc-1-nsg"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_virtual_network" "test_advanced_network" {
  name                = "akc-1-vnet"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  address_space       = ["10.175.12.0/22"]
}

resource "azurerm_subnet" "test_subnet" {
  name                      = "${var.prefix}-subnet"
  resource_group_name       = "${azurerm_resource_group.test.name}"
  network_security_group_id = "${azurerm_network_security_group.test_advanced_network.id}"
  address_prefix            = "10.175.12.0/24"
  virtual_network_name      = "${azurerm_virtual_network.test_advanced_network.name}"
}

resource "azurerm_kubernetes_cluster" "test" {
  name       = "${var.prefix}-akc-1"
  location   = "${azurerm_resource_group.test.location}"
  dns_prefix = "${var.prefix}-akc-1"
  resource_group_name = "${azurerm_resource_group.test.name}"
  kubernetes_version  = "1.12.5"

  linux_profile {
    admin_username = "acctestuser1"

    ssh_key {
      key_data = ""
    }
  }

  agent_pool_profile {
    name    = "agentpool"
    count   = "2"
    vm_size = "Standard_DS2_v2"
    os_type = "Linux"

    # Required for advanced networking
    vnet_subnet_id = "${azurerm_subnet.test_subnet.id}"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  network_profile {
    network_plugin = "azure"
  }
}

