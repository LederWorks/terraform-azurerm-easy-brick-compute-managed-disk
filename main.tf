resource "azurerm_managed_disk" "managed_disk" {
  lifecycle {
    ignore_changes = [
      encryption_settings,
      create_option,
      source_resource_id
    ]
  }

  for_each = { for obj in var.managed_disk : obj.managed_disk_name => obj }

  #Timeouts
  timeouts {
    create = coalesce(each.value.managed_disk_timeout_create, var.managed_disk_timeout_create)
    update = coalesce(each.value.managed_disk_timeout_update, var.managed_disk_timeout_update)
    read   = coalesce(each.value.managed_disk_timeout_read, var.managed_disk_timeout_read)
    delete = coalesce(each.value.managed_disk_timeout_delete, var.managed_disk_timeout_delete)
  }

  #Resource Group
  resource_group_name = var.resource_group_object.name
  location            = var.resource_group_object.location

  #Required
  name                 = each.value.managed_disk_name
  storage_account_type = each.value.managed_disk_storage_type

  #Create Options
  create_option              = coalesce(each.value.managed_disk_create_option, "Empty")
  image_reference_id         = each.value.managed_disk_create_option == "FromImage" ? each.value.managed_disk_marketplace_reference_id : null
  gallery_image_reference_id = each.value.managed_disk_create_option == "FromImage" ? each.value.managed_disk_gallery_reference_id : null
  source_resource_id         = each.value.managed_disk_create_option == "Copy" || each.value.managed_disk_create_option == "Restore" ? each.value.managed_disk_source_resource_id : null
  source_uri                 = each.value.managed_disk_create_option == "Import" ? each.value.managed_disk_source_uri : null
  storage_account_id         = each.value.managed_disk_create_option == "Import" ? each.value.managed_disk_source_storage_id : null
  os_type                    = each.value.managed_disk_create_option == "Copy" || each.value.managed_disk_create_option == "Import" ? each.value.managed_disk_os_type : null
  hyper_v_generation         = each.value.managed_disk_create_option == "Copy" || each.value.managed_disk_create_option == "Import" ? each.value.managed_disk_hyper_v_generation : "V1"

  #Disk Options
  disk_size_gb        = each.value.managed_disk_create_option != "Import" || each.value.managed_disk_create_option != "Restore" ? each.value.managed_disk_size_gb : null
  logical_sector_size = each.value.managed_disk_storage_type == "UltraSSD_LRS" ? coalesce(each.value.managed_disk_sector_size, 4096) : null
  tier                = each.value.managed_disk_storage_type == "Premium_LRS" || each.value.managed_disk_storage_type == "Premium_ZRS" ? each.value.managed_disk_tier : null
  max_shares          = ((each.value.managed_disk_storage_type == "Premium_LRS" || each.value.managed_disk_storage_type == "Premium_ZRS") && each.value.managed_disk_tier == null) || each.value.managed_disk_storage_type == "UltraSSD_LRS" ? each.value.managed_disk_max_shares : null
  zone                = each.value.managed_disk_zone

  #Ultra SSD Options
  disk_iops_read_write = each.value.managed_disk_storage_type == "UltraSSD_LRS" ? each.value.managed_disk_iops_read_write : null
  disk_iops_read_only  = each.value.managed_disk_storage_type == "UltraSSD_LRS" ? each.value.managed_disk_iops_read_only : null
  disk_mbps_read_write = each.value.managed_disk_storage_type == "UltraSSD_LRS" ? each.value.managed_disk_mbps_read_write : null
  disk_mbps_read_only  = each.value.managed_disk_storage_type == "UltraSSD_LRS" ? each.value.managed_disk_mbps_read_only : null

  #Network Options
  public_network_access_enabled = coalesce(each.value.managed_disk_public_access_enabled, true)
  network_access_policy         = coalesce(each.value.managed_disk_access_policy, "AllowAll")
  disk_access_id                = each.value.managed_disk_access_policy == "AllowPrivate" ? each.value.managed_disk_access_id : null

  #Encryption Options
  disk_encryption_set_id = each.value.managed_disk_encryption_set_id != null || var.managed_disk_encryption_set_id != null ? coalesce(each.value.managed_disk_encryption_set_id, var.managed_disk_encryption_set_id) : null

  #Tags
  tags = local.tags
}