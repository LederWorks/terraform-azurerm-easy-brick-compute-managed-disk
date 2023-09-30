#Resource Group
resource "azurerm_resource_group" "rgrp-tde3-it-terratest-compute-disk" {
  name     = "rgrp-tde3-it-terratest-compute-disk"
  location = "Germany West Central"
  tags = local.tags
}