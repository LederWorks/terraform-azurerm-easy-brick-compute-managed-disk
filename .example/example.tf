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
      name         = "managed-disk-001"
      storage_type = "Premium_LRS"

      #Create Options
      create_option            = ""
      marketplace_reference_id = ""
      gallery_reference_id     = ""
      source_resource_id       = ""
      source_uri               = ""
      source_storage_id        = ""
      os_type                  = ""
      hyper_v_generation       = ""

      #Disk Options
      size_gb     = 63
      sector_size = number
      tier        = ""
      max_shares  = number
      zone        = 3

      #Ultra SSD Options
      iops_read_write = ""
      iops_read_only  = ""
      mbps_read_write = ""
      mbps_read_only  = ""

      #Network Options
      public_access_enabled = bool
      access_policy         = ""
      access_id             = ""

      #Encryption
      encryption_set_id = ""

      #Timeouts
      timeout_create = ""
      timeout_update = ""
      timeout_read   = ""
      timeout_delete = ""


    },

    ##################
    #### Disk 002 ####
    ##################
    {
      name         = "managed-disk-002"
      storage_type = "Standard_LRS"
      size_gb      = 63
      zone         = 3
    }
  ]
}
output "managed_disk_list" {
  value = module.compute-managed-disk.managed_disk_list
}
