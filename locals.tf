locals {
  #Tags
  tags = merge({
    creation-mode                                     = "terraform",
    terraform-azurerm-easy-brick-compute-managed-disk = "True"
  }, var.tags)
}