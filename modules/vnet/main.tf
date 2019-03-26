
variable "prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "mod-test-int"
}

variable "rg-name" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "zz"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "southcentralus"
}

variable "net_id" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default     = "1"
}

resource "azurerm_resource_group" "rg" {
  count     = "${var.rg-name == "zz" ? 1 : 0}"
  name      = "${var.prefix}-rg"
  location  = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = "${var.location}"
  address_space       = ["10.${var.net_id}.0.0/16"]
  resource_group_name = "${join("", azurerm_resource_group.rg.*.id) == "" ? var.rg-name : join("", azurerm_resource_group.rg.*.name) }"
  depends_on = ["null_resource.dependent-res"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_virtual_network.vnet.resource_group_name}"
  address_prefix       = "10.${var.net_id}.2.0/24"
  depends_on  = ["azurerm_virtual_network.vnet"]
}

output "vnet_ids" {
  description = "Virtual networks ids created."
  value       = "${azurerm_virtual_network.vnet.*.id}"
}
