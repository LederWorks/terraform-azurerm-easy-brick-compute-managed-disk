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
      name = "ddsk-001-tde3ictest001"
      storage_type = "Premium_LRS"
      size_gb = 63
      zone = 3
    },
    #Disk2
    {
      name = "ddsk-002-tde3ictest001"
      storage_type = "Standard_LRS"
      size_gb = 63
      zone = 3
    }
  ]

}
