# Module Test
module "terratest-category-purpose" {
  source = "../"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.rgrp-tde3-it-terratest-compute-disk

  #Tags
  tags = local.tags

  ### Global Variables ###



  ### Local Variables ###
  managed_disk = [
    #Disk1
    {
      managed_disk_name = "ddsk-001-tde3ictest001"
      managed_disk_storage_type = "Premium_LRS"
      managed_disk_size_gb = 63
      managed_disk_zone = 3
    },
    #Disk2
    {
      managed_disk_name = "ddsk-002-tde3ictest001"
      managed_disk_storage_type = "Standard_LRS"
      managed_disk_size_gb = 63
      managed_disk_zone = 3
    }
  ]

}
