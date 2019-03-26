
variable "prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "mod-test"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "southcentralus"
}


resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "10.0.2.0/24"
}

module "2nd_vnet" {
  source = "modules/vnet"
  net_id = "2"
}

module "3nd_vnet" {
  source = "modules/vnet"
  prefix = "abcd"
  net_id = "3"
}
module "4nd_vnet" {
  source = "modules/vnet"
  prefix = "abcd2"
  net_id = "4"
  rg-name = "abcd-rg"
  depends_on = ["${module.3nd_vnet.anchor}", "${azurerm_virtual_network.vnet.name}"]
}
