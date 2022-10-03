locals {
  #Tags
  tags = merge({
    creation_mode                               = "terraform",
    terraform-azurerm-easy-brick-compute-managed_disk = "True"
  }, var.tags)
}