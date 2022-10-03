#Resource Group
resource "azurerm_resource_group" "compute-managed-disk" {
  name     = "compute-managed-disk"
  location = "East US 2"
  tags     = local.tags
}

#Managed Disk Module
module "compute-managed-disk" {
  source  = "LederWorks/easy-brick-compute-managed-disk/azurerm"
  version = "X.X.X"

  # Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  # Resource Group
  resource_group_object = azurerm_resource_group.compute-managed-disk

  # Tags
  tags = local.tags

  managed_disk = [

    #################################
    #### Disk 001 - Full Example ####
    #################################
    {
      #Required
      managed_disk_name         = "managed-disk-001"
      managed_disk_storage_type = "Premium_LRS"

      #Create Options
      managed_disk_create_option            = ""
      managed_disk_marketplace_reference_id = ""
      managed_disk_gallery_reference_id     = ""
      managed_disk_source_resource_id       = ""
      managed_disk_source_uri               = ""
      managed_disk_source_storage_id        = ""
      managed_disk_os_type                  = ""
      managed_disk_hyper_v_generation       = ""

      #Disk Options
      managed_disk_size_gb     = 63
      managed_disk_sector_size = number
      managed_disk_tier        = ""
      managed_disk_max_shares  = number
      managed_disk_zone        = 3

      #Ultra SSD Options
      managed_disk_iops_read_write = ""
      managed_disk_iops_read_only  = ""
      managed_disk_mbps_read_write = ""
      managed_disk_mbps_read_only  = ""

      #Network Options
      managed_disk_public_access_enabled = bool
      managed_disk_access_policy         = ""
      managed_disk_access_id             = ""

      #Encryption
      managed_disk_encryption_set_id = ""

      #Timeouts
      managed_disk_timeout_create = ""
      managed_disk_timeout_update = ""
      managed_disk_timeout_read   = ""
      managed_disk_timeout_delete = ""


    },

    ##################
    #### Disk 002 ####
    ##################
    {
      managed_disk_name         = "managed-disk-002"
      managed_disk_storage_type = "Standard_LRS"
      managed_disk_size_gb      = 63
      managed_disk_zone         = 3
    }
  ]
}



#Outputs
#auth
output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

#rgrp
output "resource_group_name" {
  value = azurerm_resource_group.compute-managed-disk.name
}

#disks
output "managed_disk_list" {
  value = module.compute-managed-disk.managed_disk_list
}