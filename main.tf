resource "azurerm_managed_disk" "managed_disk" {
  lifecycle {
    ignore_changes = [
      encryption_settings,
      create_option,
      source_resource_id
    ]
  }

  for_each = var.managed_disk != null ? { for obj in var.managed_disk : obj.name => obj } : {}

  #Timeouts
  timeouts {
    create = coalesce(each.value.timeout_create, var.managed_disk_timeout_create)
    update = coalesce(each.value.timeout_update, var.managed_disk_timeout_update)
    read   = coalesce(each.value.timeout_read, var.managed_disk_timeout_read)
    delete = coalesce(each.value.timeout_delete, var.managed_disk_timeout_delete)
  }

  #Resource Group
  resource_group_name = var.resource_group_object.name
  location            = var.resource_group_object.location

  #Required
  name                 = each.value.name
  storage_account_type = each.value.storage_type

  #Create Options
  create_option              = coalesce(each.value.create_option, "Empty")
  image_reference_id         = each.value.create_option == "FromImage" ? each.value.marketplace_reference_id : null
  gallery_image_reference_id = each.value.create_option == "FromImage" ? each.value.gallery_reference_id : null
  source_resource_id         = each.value.create_option == "Copy" || each.value.create_option == "Restore" ? each.value.source_resource_id : null
  source_uri                 = each.value.create_option == "Import" ? each.value.source_uri : null
  storage_account_id         = each.value.create_option == "Import" ? each.value.source_storage_id : null
  os_type                    = each.value.create_option == "Copy" || each.value.create_option == "Import" ? each.value.os_type : null
  hyper_v_generation         = each.value.create_option == "Copy" || each.value.create_option == "Import" ? each.value.hyper_v_generation : "V1"
  upload_size_bytes          = each.value.create_option == "Upload" ? each.value.upload_size_bytes : null

  #Disk Options
  disk_size_gb        = each.value.create_option != "Import" || each.value.create_option != "Restore" ? each.value.size_gb : null
  logical_sector_size = each.value.storage_type == "UltraSSD_LRS" ? coalesce(each.value.sector_size, 4096) : null
  tier                = each.value.storage_type == "Premium_LRS" || each.value.storage_type == "Premium_ZRS" ? each.value.tier : null
  max_shares          = ((each.value.storage_type == "Premium_LRS" || each.value.storage_type == "Premium_ZRS") && each.value.tier == null) || each.value.storage_type == "UltraSSD_LRS" ? each.value.max_shares : null
  zone                = each.value.zone

  #Ultra SSD Options
  disk_iops_read_write = each.value.storage_type == "UltraSSD_LRS" ? each.value.iops_read_write : null
  disk_iops_read_only  = each.value.storage_type == "UltraSSD_LRS" ? each.value.iops_read_only : null
  disk_mbps_read_write = each.value.storage_type == "UltraSSD_LRS" ? each.value.mbps_read_write : null
  disk_mbps_read_only  = each.value.storage_type == "UltraSSD_LRS" ? each.value.mbps_read_only : null

  #Network Options
  public_network_access_enabled = coalesce(each.value.public_access_enabled, true)
  network_access_policy         = coalesce(each.value.access_policy, "AllowAll")
  disk_access_id                = each.value.access_policy == "AllowPrivate" ? each.value.access_id : null

  #Encryption Options
  disk_encryption_set_id = each.value.encryption_set_id != null || var.managed_disk_encryption_set_id != null ? coalesce(each.value.encryption_set_id, var.managed_disk_encryption_set_id) : null

  #Tags
  tags = local.tags
}